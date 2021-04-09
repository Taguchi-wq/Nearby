//
//  ClientError.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/09.
//

import Foundation

public enum ClientError: String, Error {
    case invalidShop = "検索した店舗が存在しませんでした。もう一度やり直してください。"
    case unableToConnect   = "リクエストが完了しませんでした。インターネット接続を確認してください。"
    case invalidData       = "サーバーから受信したデータが無効でした。もう一度やり直してください。"
}
