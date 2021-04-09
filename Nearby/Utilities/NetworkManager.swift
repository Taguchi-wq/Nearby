//
//  NetworkManager.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/09.
//

import Foundation

/// APIを用いた通信を行う
struct NetworkManager {
    
    // MARK: - Propetys
    static  let shared  = NetworkManager()
    private let baseURL = "https://webservice.recruit.co.jp/"
    private let path    = "hotpepper/gourmet/v1/?key="
    private let apiKey  = "07bb9f8aa0569538"
    
    
    // MARK: - Initialize
    private init() {}
    
    
    // MARK: - Methods
    /// 店舗のデータを取得する
    /// - Parameters:
    ///   - keyword: 検索キーワード
    ///   - latitude: 店舗の緯度
    ///   - longitude: 店舗の経度
    ///   - completion: 処理終了後
    func getShop(_ keyword: String, latitude: Double, longitude: Double, completion: @escaping (Result<[Shop], ClientError>) -> Void) {
        let hotPepperURL = baseURL + path + apiKey + "&keyword=\(keyword)&lat=\(latitude)&lng=\(longitude)&format=json"
        let encodeURL = hotPepperURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // URLが存在しなかった時の処理
        guard let url = URL(string: encodeURL) else {
            print(hotPepperURL)
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
                print(error)
            }
            
        }.resume()
        
    }
    
}
