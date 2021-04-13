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
    
    
    // MARK: - Propetys
    /// ConditionsDelegate
    private weak var delegate: ConditionsDelegate?
    /// 検索範囲
    private var selectedRange: SelectedRange = .meters1000
    /// 個室の有無
    private var selectedPrivateRoom: SelectedPrivateRoom = .notNarrowDown
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adaptButton.layer.cornerRadius = 10
        setupSegmentedControl(selectedRange: selectedRange, selectedPrivateRoom: selectedPrivateRoom)
    }
    
    /// SearchConditionsViewControllerを初期化する
    /// - Parameters:
    ///   - delegate: ConditionsDelegate
    ///   - selectedRange: 検索範囲
    ///   - selectedPrivateRoom: 個室の有無
    func initialize(delegate: ConditionsDelegate, selectedRange: SelectedRange, selectedPrivateRoom: SelectedPrivateRoom) {
        self.delegate            = delegate
        self.selectedRange       = selectedRange
        self.selectedPrivateRoom = selectedPrivateRoom
    }
    
    /// SegmentedControlの設定をする
    /// - Parameters:
    ///   - selectedRange: 検索範囲
    ///   - selectedPrivateRoom: 個室の有無
    private func setupSegmentedControl(selectedRange: SelectedRange, selectedPrivateRoom: SelectedPrivateRoom) {
        // SegmentedControlの初期値
        rangeSegmentedControl.selectedSegmentIndex       = selectedRange.rawValue - 1
        privateRoomSegmentedControl.selectedSegmentIndex = selectedPrivateRoom.rawValue
        // 文字の色を白にする
        rangeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        privateRoomSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    
    
    // MARK: - @IBActions
    @IBAction private func selectedRange(_ sender: UISegmentedControl) {
        if let selectedRange = SelectedRange(rawValue: sender.selectedSegmentIndex + 1) {
            self.selectedRange = selectedRange
        }
    }
    
    @IBAction private func selectedPrivateRoom(_ sender: UISegmentedControl) {
        if let selectedPrivateRoom = SelectedPrivateRoom(rawValue: sender.selectedSegmentIndex) {
            self.selectedPrivateRoom = selectedPrivateRoom
        }
    }
    
    @IBAction private func adapt(_ sender: Any) {
        delegate?.adaptedConditions(selectedRange: selectedRange, selectedPrivateRoom: selectedPrivateRoom)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Reusable
extension SearchConditionsViewController: Reusable {}
