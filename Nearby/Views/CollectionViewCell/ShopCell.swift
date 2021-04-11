//
//  ShopCell.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/11.
//

import UIKit

class ShopCell: UICollectionViewCell {
    
    // MARK: - @IBOutlets
    /// お店のサムネイル画像を表示するImageView
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    /// お店の名前を表示するLabel
    @IBOutlet private weak var nameLabel: UILabel!
    /// お店のジャンルを表示するLabel
    @IBOutlet private weak var genreLabel: UILabel!
    
    
    // MARK: - Mrthods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.borderWidth  = 1
        layer.borderColor  = UIColor.black.cgColor
    }
    
    /// ShopCellを初期化する
    /// - Parameters:
    ///   - imageURL: お店のサムネイルとして表示する画像のURL
    ///   - name: お店の名前
    ///   - genre: お店のジャンル  
    func initialize(imageURL: String, name: String, genre: String) {
        thumbnailImageView.setupImage(imageURL: imageURL)
        nameLabel.text  = name
        genreLabel.text = genre
    }
    
}


// MARK: - Reusable
extension ShopCell: Reusable {}
