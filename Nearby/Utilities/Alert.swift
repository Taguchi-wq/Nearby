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
    
    static func showLocationInformationPermissionAlert(on viewController: UIViewController) {
        // 位置情報の設定画面
        let settingAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(title: "位置情報が利用できません", message: "位置情報を使用することが許可されていません。”設定”で位置情報へのアクセスを有効にしてください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "設定", style: .default, handler: { _ in
            UIApplication.shared.open(settingAppURL, options: [:], completionHandler: nil)
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
