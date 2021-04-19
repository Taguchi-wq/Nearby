//
//  ConditionCell.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/08.
//

import UIKit

class ConditionCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    /// 条件を表示するlabel
    @IBOutlet private weak var conditionLabel: UILabel!
    
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// ConditionCellを初期化する
    func initialize(condition: String) {
        conditionLabel.text = condition
        layer.cornerRadius  = 10
    }
    
}


// MARK: - Reusable
extension ConditionCell: Reusable {}
