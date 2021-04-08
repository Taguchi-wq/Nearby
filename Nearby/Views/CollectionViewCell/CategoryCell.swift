//
//  CategoryCell.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/08.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    /// カテゴリーの画像を表示するimageView
    @IBOutlet private weak var categoryImageView: UIImageView!
    
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }
    
    /// CategoryCellを初期化する
    private func initialize() {
        layer.cornerRadius = 10
    }

}

// MARK: - Reusable
extension CategoryCell: Reusable {}
