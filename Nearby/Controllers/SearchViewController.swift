//
//  SearchViewController.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/08.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Enums
    /// categoryCollectionViewのレイアウトのセクション
    private enum SectionLayoutKind: CaseIterable {
        case conditions
        case categorys
    }
    

    // MARK: - @IBOutlets
    /// 検索窓口
    @IBOutlet private weak var searchField: UITextField!
    /// カテゴリーを表示するcollectionView
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    
    
    // MARK: - Propertys
    /// 条件
    private let conditions = ["500m", "クーポンあり"]
    /// カテゴリー
    private let categorys = ["ハンバーガー", "ラーメン", "寿司", "中華料理", "居酒屋", "焼肉", "カフェ", "イタリアン", "デザート"]
    
    
    // MAEK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    /// SearchViewControllerを初期化する
    private func initialize() {
        setupCollectionView(categoryCollectionView)
        setupTextField(searchField)
    }
    
    /// TextFieldの設定を行う
    /// - Parameter textField: 設定したいTextField
    private func setupTextField(_ textField: UITextField) {
        textField.delegate = self
    }
    
    /// CollectionViewの設定を行う
    /// - Parameter collectionView: 設定したいCollectionView
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(UINib(nibName: CategoryCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.register(UINib(nibName: ConditionCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: ConditionCell.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
    }
    
    /// SearchResultViewControllerにkeywordを渡して画面遷移する
    /// - Parameter keyword: 検索したいキーワード
    private func transitionSearchResultViewController(keyword: String) {
        let searchResultViewController = storyboard?.instantiateViewController(withIdentifier: SearchResultViewController.reuseIdentifier) as! SearchResultViewController
        searchResultViewController.initialize(keyword: keyword)
        navigationController?.pushViewController(searchResultViewController, animated: true)
    }

}


// MARK: - Layout
extension SearchViewController {
    
    /// SearchViewControllerのレイアウトを作る
    /// - Returns: SearchViewControllerのレイアウト
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = SectionLayoutKind.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .conditions:
                return self.conditionsLayout()
            case .categorys:
                return self.categorysLayout()
            }
        }
        return layout
    }
    
    /// 条件を表示するレイアウト
    /// - Returns: 条件を表示するレイアウト
    private func conditionsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1),
                                               heightDimension: .fractionalHeight(0.07))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 50, leading: 30, bottom: 10, trailing: 10)
        
        return section
    }
    
    /// カテゴリーを表示するレイアウト
    /// - Returns: カテゴリーを表示するレイアウト
    private func categorysLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(categoryCollectionView.bounds.width / 3 - 50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 30
        section.contentInsets = .init(top: 80, leading: 30, bottom: 30, trailing: 30)
        
        return section
    }
    
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionLayoutKind.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return categorys.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let conditionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConditionCell.reuseIdentifier, for: indexPath) as! ConditionCell
            conditionCell.initialize(condition: conditions[indexPath.row])
            return conditionCell
        default:
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
            categoryCell.initialize(imageName: categorys[indexPath.row])
            return categoryCell
        }
    }
    
}


// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            transitionSearchResultViewController(keyword: categorys[indexPath.row])
        }
    }
}


// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    // キーボードの検索ボタンが押された時に呼ばれる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 入力されているキーワードで飲食店を探す
        guard let keyword = searchField.text else { return true }
        transitionSearchResultViewController(keyword: keyword)
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
}
