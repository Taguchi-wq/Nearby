//
//  SearchConditionsViewController.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/12.
//

import UIKit

class SearchConditionsViewController: UIViewController {
    
    // MARK: - @IBOutlets
    /// 検索したい距離を選択するSegmentedControl
    @IBOutlet private weak var rangeSegmentedControl: UISegmentedControl!
    /// 個室の有無を選択するSegmentedControl
    @IBOutlet private weak var privateRoomSegmentedControl: UISegmentedControl!
    /// 条件を適応させるボタン
    @IBOutlet private weak var adaptButton: UIButton!
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adaptButton.layer.cornerRadius = 10
    }

    
    // MARK: - @IBActions
    @IBAction func adapt(_ sender: Any) {
    }
    
}


// MARK: - Reusable
extension SearchConditionsViewController: Reusable {}
