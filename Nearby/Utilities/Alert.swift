//
//  Alert.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/11.
//

import UIKit

struct Alert {
    
    /// アラートを表示する
    /// - Parameters:
    ///   - viewController: アラートを表示したいViewController
    ///   - title: アラートのタイトル
    ///   - message: アラートのメッセージ
    static func present(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
