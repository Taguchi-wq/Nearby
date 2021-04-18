//
//  KeyManager.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/18.
//

import Foundation

/// プロパティファイルの情報を操作する
struct KeyManager {
    
    // MARK: - Initializer
    // イニシャライザを他から実行されないようにする
    private init() {}
    
    
    // MARK: - Propertys
    /// URL.plistファイルを1回だけ読み込む
    private static let urlProperties = loadingURLPropertiesFile()
    
    
    // MARK: - Methods
    /// URL.plistファイルを読み込む
    /// - Returns: keyがString、valueがAnyの辞書型
    private static func loadingURLPropertiesFile() -> [String : Any] {
        guard let path       = Bundle.main.path(forResource: "URL", ofType: "plist") else { return [:] }
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String : Any] else { return [:] }
        return dictionary
    }
    
    /// URL.plistファイルのValueをStringで得る
    /// - Parameter key: key名
    /// - Returns: keyに対応するvalue、keyに対応する値がない場合、Stringではない場合はnil
    static func getValue(_ key: String) -> String {
        return urlProperties[key] as? String ?? ""
    }
    
}
