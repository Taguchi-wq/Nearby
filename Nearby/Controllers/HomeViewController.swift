//
//  HomeViewController.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/11.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    // MARK: - Enums
    /// shopCollectionViewのレイアウトのセクション
    private enum SectionLayoutKind: CaseIterable {
        case categorys
        case shops
    }
    
    
    // MARK: - @IBOutlets
    /// 近くのお店の情報を表示するCollectionView
    @IBOutlet private weak var shopsCollectionView: UICollectionView!
    
    
    // MARK: - Propetys
    /// ロケーションマネジャー
    private let locationManager = CLLocationManager()
    /// 現在地の緯度
    private var latitude = Double()
    /// 現在地の経度
    private var longitude = Double()
    /// お店のデータ
    private var shops: [Shop] = []
    /// カテゴリー
    private let categorys = ["ハンバーガー", "ラーメン", "寿司", "中華料理", "居酒屋", "焼肉", "カフェ", "イタリアン", "デザート"]
    

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        setupCollectionView(shopsCollectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(latitude, longitude)
        getShop(keyword: "", latitude: latitude, longitude: longitude)
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
            getLocation()
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
    
    /// CollectionViewの設定を行う
    /// - Parameter collectionView: 設定したいCollectionView
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(UINib(nibName: CategoryCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.register(UINib(nibName: ShopCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: ShopCell.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
    }
    
    /// 近くの店舗を取得する
    /// - Parameter keyword: 検索キーワード
    private func getShop(keyword: String, latitude: Double, longitude: Double) {
        NetworkManager.shared.getShop(keyword, latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let shops):
                self.updateUI(shops: shops)
            case .failure(let error):
                self.searchFailure(error: error)
            }
        }
    }
    
    /// UIの表示を更新する
    /// - Parameter shops: 取得した店舗
    private func updateUI(shops: [Shop]) {
        self.shops = []
        self.shops.append(contentsOf: shops)
        DispatchQueue.main.async {
            self.shopsCollectionView.reloadData()
        }
    }
    
    /// 検索に失敗
    /// - Parameter error: エラー
    private func searchFailure(error: ClientError) {
        self.shops = []
        DispatchQueue.main.async {
            self.shopsCollectionView.reloadData()
            Alert.showBasic(on: self, message: error.rawValue)
        }
    }
    
}


// MARK: - Layout
extension HomeViewController {
    
    /// HomeViewControllerのレイアウトを作る
    /// - Returns: HomeViewControllerのレイアウト
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = SectionLayoutKind.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .categorys:
                return self.categorysLayout()
            case .shops:
                return self.shopsLayout()
            }
        }
        return layout
    }
    
    /// カテゴリーを表示するレイアウト
    /// - Returns: カテゴリーを表示するレイアウト
    private func categorysLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return section
    }
    
    /// 近くのお店を表示するレイアウト
    /// - Returns: 近くのお店を表示するレイアウト
    private func shopsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = .init(top: 20, leading: 10, bottom: 20, trailing: 10)
        
        return section
    }
    
}


// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionLayoutKind.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return categorys.count
        default:
            return shops.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
            categoryCell.initialize(imageName: categorys[indexPath.row])
            return categoryCell
        default:
            let shopCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCell.reuseIdentifier, for: indexPath) as! ShopCell
            let shop = shops[indexPath.row]
            shopCell.initialize(imageURL: shop.photo.pc.l, name: shop.name, genre: shop.genre.name)
            return shopCell
        }
    }
    
}


// MARK: -
extension HomeViewController: UICollectionViewDelegate {}


// MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
