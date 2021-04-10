//
//  ShopOpenCell.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/11.
//

import UIKit

class ShopOpenCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    /// 店舗のオープン時間を表示するLabel
    @IBOutlet private weak var openLabel: UILabel!
    
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// ShopOpenCellを初期化する
    /// - Parameter open: 店舗のオープン時間
    func initialize(open: String) {
        openLabel.text = open
    }

}


// MARK: - Reusable
extension ShopOpenCell: Reusable {}
