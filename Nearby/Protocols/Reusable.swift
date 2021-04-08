//
//  Reusable.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/08.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
