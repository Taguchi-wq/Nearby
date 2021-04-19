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
    }
    
    /// CategoryCellを初期化する
    func initialize(imageName: String) {
        categoryImageView.image = UIImage(named: imageName)
        layer.cornerRadius      = 10
    }

}

// MARK: - Reusable
extension CategoryCell: Reusable {}
