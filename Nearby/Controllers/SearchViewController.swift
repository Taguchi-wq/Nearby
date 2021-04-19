//
//  SearchViewController.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/08.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - @IBOutlets
    /// 検索窓口
    @IBOutlet private weak var searchField: UITextField!
    /// カテゴリーを表示するcollectionView
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    
    
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
    /// - Parameter delegate: SearchViewDelegate
    private func transitionSearchResultViewController(keyword: String, delegate: SearchViewDelegate) {
        let searchResultViewController = storyboard?.instantiateViewController(withIdentifier: SearchResultViewController.reuseIdentifier) as! SearchResultViewController
        searchResultViewController.initialize(keyword: keyword, delegate: self)
        navigationController?.pushViewController(searchResultViewController, animated: true)
    }
    
}


// MARK: - Layout
extension SearchViewController {
    
    /// SearchViewControllerのレイアウトを作る
    /// - Returns: SearchViewControllerのレイアウト
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(categoryCollectionView.bounds.width / 3 - 50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = .init(top: 80, leading: 20, bottom: 0, trailing: 20)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.categorys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        categoryCell.initialize(imageName: Constants.categorys[indexPath.row])
        return categoryCell
    }
    
}


// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        transitionSearchResultViewController(keyword: Constants.categorys[indexPath.row], delegate: self)
        searchField.resignFirstResponder()
    }
}


// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    // キーボードの検索ボタンが押された時に呼ばれる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 入力されているキーワードで飲食店を探す
        guard let keyword = searchField.text else { return true }
        transitionSearchResultViewController(keyword: keyword, delegate: self)
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
}


// MARK: - SearchViewDelegate
extension SearchViewController: SearchViewDelegate {
    // SearchViewにかえってきた値をsearchFieldにセットする
    func setupTextFieldValue(_ value: String) {
        searchField.text = value
    }
}
