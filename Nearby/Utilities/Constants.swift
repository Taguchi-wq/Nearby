//
//  Constants.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/12.
//

import Foundation

/// 検索範囲
public enum SelectedRange: Int {
    case meters300  = 1
    case meters500  = 2
    case meters1000 = 3
    case meters2000 = 4
    case meters3000 = 5
}

/// 個室の有無
public enum SelectedPrivateRoom: Int {
    case notNarrowDown = 0
    case narrowDown    = 1
}
