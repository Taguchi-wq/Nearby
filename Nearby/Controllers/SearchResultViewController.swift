//
//  SearchResultViewController.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/09.
//

import UIKit
import MapKit
import CoreLocation

class SearchResultViewController: UIViewController {

    // MARK: - @IBOutlets
    /// 検索窓口
    @IBOutlet private weak var searchTextField: UITextField!
    /// マップ
    @IBOutlet private weak var mapView: MKMapView!
    
    
    // MARK: - Propetys
    /// 店舗のデータ
    private var shops: [Shop] = []
    /// 検索したキーワード
    private var keyword = String()
    /// ロケーションマネジャー
    private let locationManager = CLLocationManager()
    /// 現在地の緯度
    private var latitude = Double()
    /// 現在地の経度
    private var longitude = Double()
    /// マップに表示する範囲
    private let regionInMeters: Double = 1000
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        displayShops()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    /// SearchResultViewControllerの初期化をする
    /// - Parameter keyword: 検索したキーワード
    func initialize(keyword: String) {
        self.keyword = keyword
    }
    
    /// 画面に店舗を表示する
    private func displayShops() {
        getShop(keyword)
        searchTextField.text = keyword
    }
    
    /// 近くの店舗を取得する
    /// - Parameter keyword: 検索キーワード
    private func getShop(_ keyword: String) {
        NetworkManager.shared.getShop(keyword, latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let shops):
                print(shops)
                self.updateMap(shops: shops)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    /// マップの表示を更新する
    /// - Parameter shops: 取得した店舗
    private func updateMap(shops: [Shop]) {
        self.shops = []
        self.shops.append(contentsOf: shops)
        DispatchQueue.main.async {
            self.putAnnotations()
        }
    }
    
    /// マップ上にピンを置く
    private func putAnnotations() {
        var annotations: [MKPointAnnotation] = []
        for i in 0..<shops.count {
            let latitude  = shops[i].lat
            let longitude = shops[i].lng
            
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotations.append(pin)
        }
        mapView.addAnnotations(annotations)
    }
    
    /// locationManagerの設定を行う
    private func setupLocationManager() {
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// デバイスの位置情報が有効になっているかどうかを確認する
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // TODO: デバイス自体の位置情報をオンにすることを促すアラートを表示する
            // ユーザーは、[設定]> [プライバシー]で[位置情報サービス]スイッチを切り替えて、位置情報サービスを有効または無効にできます。
        }
    }
    
    /// 現在地をマップの中心にする
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    /// 位置情報の認証状態を確認する
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    
    // MARK: - @IBActions
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - CLLocationManagerDelegate
extension SearchResultViewController: CLLocationManagerDelegate {
    // ユーザーが移動すると呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 現在地の緯度経度を取得しlatitudeとlongitude変数に格納する
        guard let location = locations.last else { return }
        latitude  = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    // 位置情報の認証状態が変更された時に呼ばれる
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}


// MARK: - Reusable
extension SearchResultViewController: Reusable {}
