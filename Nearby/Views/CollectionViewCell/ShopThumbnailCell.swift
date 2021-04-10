//
//  ShopThumbnailCell.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/10.
//

import UIKit

class ShopThumbnailCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    /// 店舗の画像を表示するImageView
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    /// 前の画面に戻るボタン
    @IBOutlet private weak var backButton: UIButton!
    
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backButton.layer.cornerRadius = backButton.bounds.height / 2
    }
    
    /// ShopThumbnailCellを初期化する
    /// - Parameter imageURL: 表示したい画像のURL
    func initialize(imageURL: String) {
        thumbnailImageView.setupImage(imageURL: imageURL)
    }
    
    
    // MARK: - @IBActions
    @IBAction func back(_ sender: Any) {
    }
    
}


// MARK: - Reusable
extension ShopThumbnailCell: Reusable {}
