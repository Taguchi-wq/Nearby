//
//  SearchResultViewController.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/09.
//

import UIKit
import MapKit
import CoreLocation
import JGProgressHUD

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
    /// 検索範囲
    private var selectedRange: SelectedRange = .meters1000
    /// 個室の有無
    private var selectedPrivateRoom: SelectedPrivateRoom = .notNarrowDown
    /// クルクル
    private let indicator = JGProgressHUD()
    /// SearchViewDelegate
    private weak var delegate: SearchViewDelegate?
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(searchTextField)
        setupCollectionView(shopsCollectionView)
        setupMapView(mapView)
        checkLocationServices()
        displayShops(keyword: keyword, latitude: latitude, longitude: longitude, range: selectedRange, privateRoom: selectedPrivateRoom)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden            = true
    }
    
    /// SearchResultViewControllerの初期化をする
    /// - Parameter keyword: 検索したキーワード
    /// - Parameter delegate: SearchViewDelegate
    func initialize(keyword: String, delegate: SearchViewDelegate?) {
        self.keyword  = keyword
        self.delegate = delegate
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
        collectionView.register(UINib(nibName: SearchResultShopCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: SearchResultShopCell.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
    }
    
    /// MapViewの設定を行う
    /// - Parameter mapView: 設定したいmapView
    private func setupMapView(_ mapView: MKMapView) {
        mapView.delegate = self
    }
    
    /// 画面に店舗を表示する
    /// - Parameters:
    ///   - keyword: 検索したいキーワード
    ///   - latitude: 現在地の緯度
    ///   - longitude: 現在地の経度
    ///   - range: 検索範囲
    ///   - privateRoom: 個室の有無
    private func displayShops(keyword: String, latitude: Double, longitude: Double, range: SelectedRange, privateRoom: SelectedPrivateRoom) {
        searchTextField.text = keyword
        getShop(keyword: keyword, latitude: latitude, longitude: longitude, range: range, privateRoom: privateRoom)
    }
    
    /// 近くの店舗を取得する
    /// - Parameter keyword: 検索キーワード
    /// - Parameter latitude: 現在地の緯度
    /// - Parameter longitude: 現在地の経度
    /// - Parameter range: 検索範囲
    /// - Parameter privateRoom: 個室の有無
    private func getShop(keyword: String, latitude: Double, longitude: Double, range: SelectedRange, privateRoom: SelectedPrivateRoom) {
        let components = NetworkManager.makeShopSearchURLComponents(keyword: keyword,
                                                                    latitude: latitude,
                                                                    longitude: longitude,
                                                                    range: range,
                                                                    privateRoom: privateRoom)
        NetworkManager.getShop(components) { result in
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
            self.indicator.dismiss()
        }
    }
    
    /// 検索に失敗
    /// - Parameter error: エラー
    private func searchFailure(error: ClientError) {
        self.shops = []
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.shopsCollectionView.reloadData()
            self.indicator.dismiss()
            Alert.showBasic(on: self, message: error.rawValue)
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
            pin.title      = shops[i].name
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
            indicator.show(in: view)
            locationManager.startUpdatingLocation()
        case .denied:
            Alert.showLocationInformationPermission(on: self)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 画面をタップした時にキーボードを閉じる
        searchTextField.resignFirstResponder()
    }
    
    
    // MARK: - @IBActions
    @IBAction private func back(_ sender: Any) {
        delegate?.setupTextFieldValue(keyword)
        navigationController?.popViewController(animated: true)
    }
    
    /// 検索条件を決める画面へ遷移する
    @IBAction private func determineCondition(_ sender: Any) {
        let searchConditionsViewController = storyboard?.instantiateViewController(withIdentifier: SearchConditionsViewController.reuseIdentifier) as! SearchConditionsViewController
        searchConditionsViewController.initialize(delegate: self, selectedRange: selectedRange, selectedPrivateRoom: selectedPrivateRoom)
        searchTextField.resignFirstResponder()
        present(searchConditionsViewController, animated: true, completion: nil)
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


// MARK: - MKMapViewDelegate
extension SearchResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation else { return }
        let location = selectedAnnotation.coordinate
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
}


// MARK: - UITextFieldDelegate
extension SearchResultViewController: UITextFieldDelegate {
    
    // キーボードの検索ボタンが押された時に呼ばれる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 検索窓口に入力されたキーワードで検索する
        guard let keyword = searchTextField.text else { return true }
        self.keyword = keyword
        getShop(keyword: keyword, latitude: latitude, longitude: longitude, range: selectedRange, privateRoom: selectedPrivateRoom)
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        // クルクルを回す
        indicator.show(in: self.view)
        
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
        searchResultShopCell.initialize(imageURL: shop.photo.pc.m, name: shop.name, access: shop.access)
        
        return searchResultShopCell
    }
    
}


// MARK: - UICollectionViewDelegate
extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shopDetailViewController = storyboard?.instantiateViewController(withIdentifier: ShopDetailViewController.reuseIdentifier) as! ShopDetailViewController
        
        let shop = shops[indexPath.row]
        shopDetailViewController.initialize(thumbnailURL: shop.photo.pc.l, name: shop.name, address: shop.address, open: shop.open)
        navigationController?.pushViewController(shopDetailViewController, animated: true)
    }
}


// MARK: - ConditionsDelegate
extension SearchResultViewController: ConditionsDelegate {
    func adaptedConditions(selectedRange: SelectedRange, selectedPrivateRoom: SelectedPrivateRoom) {
        self.selectedRange       = selectedRange
        self.selectedPrivateRoom = selectedPrivateRoom
        getShop(keyword: keyword, latitude: latitude, longitude: longitude, range: selectedRange, privateRoom: selectedPrivateRoom)
        self.indicator.show(in: self.view)
    }
}


// MARK: - Reusable
extension SearchResultViewController: Reusable {}
