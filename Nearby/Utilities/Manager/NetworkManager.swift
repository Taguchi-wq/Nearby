//
//  NetworkManager.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/09.
//

import Foundation

/// APIを用いた通信を行う
struct NetworkManager {
    
    // MARK: - Methods
    /// お店の情報を取得するURLのコンポーネントを作る
    /// - Parameters:
    ///   - keyword: 検索キーワード
    ///   - latitude: 店舗の緯度
    ///   - longitude: 店舗の経度
    ///   - completion: 処理終了後
    ///   - range: 検索範囲
    ///   - privateRoom: 個室の有無
    /// - Returns: URLのコンポーネント
    static func makeShopSearchURLComponents(keyword: String, latitude: Double, longitude: Double, range: SelectedRange, privateRoom: SelectedPrivateRoom) -> URLComponents {
        
        var components = URLComponents()
        components.scheme = KeyManager.getValue("Scheme")
        components.host   = KeyManager.getValue("Host")
        components.path   = KeyManager.getValue("Path")

        components.queryItems = [
            URLQueryItem(name: "key",          value: KeyManager.getValue("Key")),
            URLQueryItem(name: "format",       value: KeyManager.getValue("Format")),
            URLQueryItem(name: "count",        value: KeyManager.getValue("Count")),
            URLQueryItem(name: "keyword",      value: keyword),
            URLQueryItem(name: "lat",          value: String(latitude)),
            URLQueryItem(name: "lng",          value: String(longitude)),
            URLQueryItem(name: "range",        value: String(range.rawValue)),
            URLQueryItem(name: "private_room", value: String(privateRoom.rawValue))
        ]
        
        return components
    }
    
    /// 店舗のデータを取得する
    /// - Parameters:
    ///   - components: URLのコンポーネント
    ///   - completion: 処理終了後
    static func getShop(_ components: URLComponents, completion: @escaping (Result<[Shop], ClientError>) -> Void) {
        // URLが存在しなかった時の処理
        guard let url = components.url else {
            completion(.failure(.invalidShop))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // 通信エラーが起きた時の処理
            if let _ = error {
                completion(.failure(.unableToConnect))
                return
            }
            
            // サーバーから受信したデータが無効な時の処理
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidData))
                return
            }
            
            // サーバーから受信したデータが無効な時の処理
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // スネークケースをキャメルケースに変換
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                let shops = searchResponse.results.shop
                if shops.isEmpty {
                    completion(.failure(.invalidShop))
                } else {
                    completion(.success(shops))
                }
                
            } catch {
                completion(.failure(.invalidAPIKey))
            }
            
        }.resume()
        
    }
    
}
