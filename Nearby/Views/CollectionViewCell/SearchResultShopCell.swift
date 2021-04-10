//
//  SearchResultShopCell.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/10.
//

import UIKit

class SearchResultShopCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    /// CellのベースのUIView
    @IBOutlet private weak var contentsView: UIView!
    /// 店舗の画像を表示するImageView
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    /// 店舗の名前を表示するLabel
    @IBOutlet private weak var nameLabel: UILabel!
    /// 店舗へのアクセスを表示するLabel
    @IBOutlet private weak var accessLabel: UILabel!
    
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
    }
    
    /// SearchResultShopCellを初期化する
    /// - Parameters:
    ///   - imageURL: サムネイルのURL
    ///   - name: 店舗名
    ///   - access: アクセス
    func initialize(imageURL: String, name: String, access: String) {
        thumbnailImageView.setupImage(imageURL: imageURL)
        nameLabel.text   = name
        accessLabel.text = access
    }

}


// MARK: - Reusable
extension SearchResultShopCell: Reusable {}
