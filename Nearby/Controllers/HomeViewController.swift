//
//  HomeViewController.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/11.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    // MARK: - Propetys
    /// ロケーションマネジャー
    private let locationManager = CLLocationManager()
    /// 現在地の緯度
    private var latitude = Double()
    /// 現在地の経度
    private var longitude = Double()
    

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
    }
    
    /// locationManagerの設定を行う
    private func setupLocationManager() {
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// 現在地の緯度経度を取得する
    private func getLocation() {
        if let location = locationManager.location?.coordinate {
            latitude  = location.latitude
            longitude = location.longitude
        }
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
    
    /// 位置情報の認証状態を確認する
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            getLocation()
        case .denied:
            Alert.showLocationInformationPermissionAlert(on: self)
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
    
}


extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
