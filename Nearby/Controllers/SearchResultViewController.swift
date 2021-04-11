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
    /// 検索した店舗を表示するCollectionView
    @IBOutlet private weak var shopsCollectionView: UICollectionView!
    
    
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
        
        setupTextField(searchTextField)
        setupCollectionView(shopsCollectionView)
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
    
    /// CollectionViewの設定を行う
    /// - Parameter collectionView: 設定したいCollectionView
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(UINib(nibName: "SearchResultShopCell", bundle: nil),
                                forCellWithReuseIdentifier: "SearchResultShopCell")
        collectionView.collectionViewLayout = createLayout()
    }
    
    /// 画面に店舗を表示する
    private func displayShops() {
        searchTextField.text = keyword
        getShop(keyword: keyword, latitude: latitude, longitude: longitude)
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
            self.shopsCollectionView.reloadData()
        }
    }
    
    /// 検索に失敗
    /// - Parameter error: エラー
    private func searchFailure(error: ClientError) {
        self.shops = []
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.shopsCollectionView.reloadData()
            Alert.present(on: self, message: error.rawValue)
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
    func checkLocationServices() {
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
            getLocation()
            locationManager.startUpdatingLocation()
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
    
    
    // MARK: - @IBActions
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - Layout
extension SearchResultViewController {
    
    /// shopsCollectionViewのレイアウトを作る
    /// - Returns: shopsCollectionViewのレイアウト
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .fractionalHeight(0.9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 5, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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


// MARK: - UICollectionViewDataSource
extension SearchResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchResultShopCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultShopCell.reuseIdentifier,
                                                                      for: indexPath) as! SearchResultShopCell
        let shop = shops[indexPath.row]
        searchResultShopCell.initialize(imageURL: shop.photo.mobile.l, name: shop.name, access: shop.access)
        
        return searchResultShopCell
    }
    
}


// MARK: - UICollectionViewDelegate
extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shopDetailViewController = storyboard?.instantiateViewController(withIdentifier: ShopDetailViewController.reuseIdentifier) as! ShopDetailViewController
        
        let shop = shops[indexPath.row]
        shopDetailViewController.initialize(thumbnailURL: shop.photo.mobile.l, name: shop.name, address: shop.address, open: shop.open)
        navigationController?.pushViewController(shopDetailViewController, animated: true)
    }
}


// MARK: - Reusable
extension SearchResultViewController: Reusable {}
