//
//  ShopNameCell.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/11.
//

import UIKit

class ShopNameCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    /// 店舗名を表示するLabel
    @IBOutlet private weak var nameLabel: UILabel!
    
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// ShopNameCellを初期化する
    /// - Parameter name: 店舗名
    func initialize(name: String) {
        nameLabel.text = name
    }

}


// MARK: - Reusable
extension ShopNameCell: Reusable {}
