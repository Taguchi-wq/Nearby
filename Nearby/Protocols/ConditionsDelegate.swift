//
//  ConditionsDelegate.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/12.
//

import Foundation

protocol ConditionsDelegate: class {
    func adaptedConditions(selectedRange: SelectedRange, selectedPrivateRoom: SelectedPrivateRoom)
}
