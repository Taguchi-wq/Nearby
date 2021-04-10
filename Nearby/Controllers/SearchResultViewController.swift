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
    private let regionInMeters: Double = 3000
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        setupTextField(searchTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayShops()
    }
    
    /// SearchResultViewControllerの初期化をする
    /// - Parameter keyword: 検索したキーワード
    func initialize(keyword: String) {
        self.keyword = keyword
    }
    
    /// TextFieldの設定を行う
    /// - Parameter textField: 設定したいTextField
    private func setupTextField(_ textField: UITextField) {
        textField.delegate = self
    }
    
    /// locationManagerの設定を行う
    private func setupLocationManager() {
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// 画面に店舗を表示する
    private func displayShops() {
        getLocation()
        getShop(keyword: keyword, latitude: latitude, longitude: longitude)
        searchTextField.text = keyword
    }
    
    /// 近くの店舗を取得する
    /// - Parameter keyword: 検索キーワード
    private func getShop(keyword: String, latitude: Double, longitude: Double) {
        NetworkManager.shared.getShop(keyword, latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let shops):
                print(shops.count)
                self.updateMap(shops: shops)
            case .failure(let error):
                self.searchFailure(error: error)
            }
        }
    }
    
    /// マップの表示を更新する
    /// - Parameter shops: 取得した店舗
    private func updateMap(shops: [Shop]) {
        self.shops = []
        self.shops.append(contentsOf: shops)
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.putAnnotations()
        }
    }
    
    /// 検索に失敗
    /// - Parameter error: エラー
    private func searchFailure(error: ClientError) {
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            print(error.rawValue)
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
    
    /// 現在地の緯度経度を取得する
    private func getLocation() {
        if let location = locationManager.location?.coordinate {
            latitude  = location.latitude
            longitude = location.longitude
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

    // 位置情報の認証状態が変更された時に呼ばれる
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}


// MARK: - UITextFieldDelegate
extension SearchResultViewController: UITextFieldDelegate {
    
    // キーボードの検索ボタンが押された時に呼ばれる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 検索窓口に入力されたキーワードで検索する
        guard let keyword = searchTextField.text else { return true }
        getShop(keyword: keyword, latitude: latitude,longitude: longitude)
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
}


// MARK: - Reusable
extension SearchResultViewController: Reusable {}
