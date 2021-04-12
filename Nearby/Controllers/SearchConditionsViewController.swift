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
        
        initialize()
    }
    
    /// SearchConditionsViewControllerを初期化する
    private func initialize() {
        adaptButton.layer.cornerRadius = 10
        setupSegmentedControl()
    }
    
    /// SegmentedControlの設定をする
    private func setupSegmentedControl() {
        rangeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        privateRoomSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }

    
    // MARK: - @IBActions
    @IBAction func adapt(_ sender: Any) {
    }
    
}


// MARK: - Reusable
extension SearchConditionsViewController: Reusable {}
