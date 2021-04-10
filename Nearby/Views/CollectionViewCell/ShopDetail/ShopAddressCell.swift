//
//  ShopAddressCell.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/11.
//

import UIKit

class ShopAddressCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    /// 店舗の住所を表示するLabel
    @IBOutlet private weak var addressLabel: UILabel!
    
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// ShopAddressCellを初期化する
    /// - Parameter address: 店舗の住所
    func initialize(address: String) {
        addressLabel.text = address
    }

}


// MARK: - Reusable
extension ShopAddressCell: Reusable {}
