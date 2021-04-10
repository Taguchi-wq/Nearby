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
    
    
    // MARK: - Propertys
    /// ShopThumbnailCellのデリゲート
    private weak var delegate: ShopThumbnailCellDelegate?
    
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 戻るボタンを丸くする
        backButton.layer.cornerRadius = backButton.bounds.height / 2
    }
    
    /// ShopThumbnailCellを初期化する
    /// - Parameter imageURL: 表示したい画像のURL
    func initialize(imageURL: String) {
        thumbnailImageView.setupImage(imageURL: imageURL)
    }
    
    /// ShopThumbnailCellDelegateの設定をする
    /// - Parameter delegate: ShopThumbnailCellDelegate
    func setupDelegate(_ delegate: ShopThumbnailCellDelegate) {
        self.delegate = delegate
    }
    
    
    // MARK: - @IBActions
    @IBAction func back(_ sender: Any) {
        delegate?.back()
    }
    
}


// MARK: - Reusable
extension ShopThumbnailCell: Reusable {}
