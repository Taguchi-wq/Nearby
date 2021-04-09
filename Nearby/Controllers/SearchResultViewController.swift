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
    private var shops: [SearchResponse] = []
    /// 検索したキーワード
    private var keyword = String()
    /// ロケーションマネジャー
    private let locationManager = CLLocationManager()
    /// マップに表示する範囲
    private let regionInMeters: Double = 1000
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        displayShops()
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
        NetworkManager.shared.getShop(keyword) { result in
            switch result {
            case .success(let shop):
                print(shop.results)
            case .failure(let error):
                print(error.rawValue)
            }
        }
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
        // ユーザーが動くたびに現在地をマップの中心にする
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    // 位置情報の認証状態が変更された時に呼ばれる
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}


// MARK: - Reusable
extension SearchResultViewController: Reusable {}
