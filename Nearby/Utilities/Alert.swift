//
//  Alert.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/11.
//

import UIKit

struct Alert {
    
    /// 基本的なアラートを構成する
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - message: アラートのメッセージ
    /// - Returns: アラート
    private static func configureBasicAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        return alert
    }
    
    /// アラートを表示する
    /// - Parameters:
    ///   - viewController: アラートを表示したいViewController
    ///   - message: アラートのメッセージ
    static func showBasic(on viewController: UIViewController, message: String) {
        let alert = configureBasicAlert(title: "エラー", message: message)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// 位置情報の使用許可を促すアラートを表示する
    /// - Parameter viewController: アラートを表示したいViewController
    static func showLocationInformationPermission(on viewController: UIViewController) {
        // 位置情報の設定画面
        let settingAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = configureBasicAlert(title: "位置情報が利用できません", message: "位置情報を使用することが許可されていません。”設定”で位置情報へのアクセスを有効にしてください")
        alert.addAction(UIAlertAction(title: "設定", style: .default, handler: { _ in
            UIApplication.shared.open(settingAppURL, options: [:], completionHandler: nil)
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
