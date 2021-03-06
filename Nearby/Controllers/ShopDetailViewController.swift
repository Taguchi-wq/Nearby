//
//  ShopDetailViewController.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/10.
//

import UIKit

class ShopDetailViewController: UIViewController {
    
    // MARK: - Enums
    /// detailCollectionViewのレイアウトのセクション
    private enum SectionLayoutKind: CaseIterable {
        case thumbnail
        case name
        case information
        case address
        case open
    }

    // MARK: - @IBOutlets
    /// 店舗の詳細を表示するCollectionView
    @IBOutlet private weak var detailCollectionView: UICollectionView!
    
    
    // MARK: - Propertys
    /// 店舗の画像のURL
    private var thumbnailURL = String()
    /// 店舗名
    private var name = String()
    /// 店舗の住所
    private var address = String()
    /// 店舗のオープン時間
    private var open = String()
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView(detailCollectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden            = true
    }
    
    /// ShopDetailViewControllerを初期化する
    /// - Parameters:
    ///   - thumbnailURL: 店舗の画像URL
    ///   - name: 店舗名
    ///   - address: 店舗の住所
    func initialize(thumbnailURL: String, name: String, address: String, open: String) {
        self.thumbnailURL = thumbnailURL
        self.name         = name
        self.address      = address
        self.open         = open
    }
    
    /// CollectionViewの設定を行う
    /// - Parameter collectionView: 設定したいCollectionView
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(UINib(nibName: ShopThumbnailCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: ShopThumbnailCell.reuseIdentifier)
        collectionView.register(UINib(nibName: ShopNameCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: ShopNameCell.reuseIdentifier)
        collectionView.register(UINib(nibName: ShopInformationCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: ShopInformationCell.reuseIdentifier)
        collectionView.register(UINib(nibName: ShopAddressCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: ShopAddressCell.reuseIdentifier)
        collectionView.register(UINib(nibName: ShopOpenCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: ShopOpenCell.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
    }
    
}


// MARK: - Layout
extension ShopDetailViewController {
    
    /// ShopDetailViewControllerのレイアウトを作る
    /// - Returns: ShopDetailViewControllerのレイアウト
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let sectionLayoutKind = SectionLayoutKind.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .thumbnail:
                return self.thumbnailLayout()
            case .name:
                return self.nameLayout()
            case .information:
                return self.informationLayout()
            case .address:
                return self.addressLayout()
            case .open:
                return self.openLayout()
            }
        }

        return layout
    }
    
    /// 店舗の画像を表示するレイアウト
    /// - Returns: 店舗の画像を表示するレイアウト
    private func thumbnailLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    /// 店舗名を表示するレイアウト
    /// - Returns: 店舗名を表示するレイアウト
    private func nameLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
    
    /// 「お店の情報」を表示するレイアウト
    /// - Returns: 「お店の情報」を表示するレイアウト
    private func informationLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
    
    /// 店舗の住所を表示するレイアウト
    /// - Returns: 店舗の住所を表示するレイアウト
    private func addressLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 5, trailing: 20)
        
        return section
    }
    
    
    /// 店舗のオープン時間を表示するレイアウト
    /// - Returns: 店舗のオープン時間を表示するレイアウト
    private func openLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
}


// MARK: - UICollectionViewDataSource
extension ShopDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionLayoutKind.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let shopThumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopThumbnailCell.reuseIdentifier, for: indexPath) as! ShopThumbnailCell
            shopThumbnailCell.initialize(imageURL: thumbnailURL)
            shopThumbnailCell.setupDelegate(self)
            return shopThumbnailCell
        case 1:
            let shopNameCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopNameCell.reuseIdentifier, for: indexPath) as! ShopNameCell
            shopNameCell.initialize(name: name)
            return shopNameCell
        case 2:
            let shopInformationCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopInformationCell.reuseIdentifier, for: indexPath) as! ShopInformationCell
            return shopInformationCell
        case 3:
            let shopAddressCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopAddressCell.reuseIdentifier, for: indexPath) as! ShopAddressCell
            shopAddressCell.initialize(address: address)
            return shopAddressCell
        default:
            let shopOpenCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopOpenCell.reuseIdentifier, for: indexPath) as! ShopOpenCell
            shopOpenCell.initialize(open: open)
            return shopOpenCell
        }
    }
    
}


// MARK: - UICollectionViewDelegate
extension ShopDetailViewController: UICollectionViewDelegate {}


// MARk: - ShopThumbnailCellDelegate
extension ShopDetailViewController: ShopThumbnailCellDelegate {
    
    /// 前の画面に戻る
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - Reusable
extension ShopDetailViewController: Reusable {}
