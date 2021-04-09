//
//  SearchResultViewController.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/09.
//

import UIKit
import MapKit

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
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: - @IBActions
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - Reusable
extension SearchResultViewController: Reusable {}
