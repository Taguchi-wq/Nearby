//
//  Shop.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/09.
//

import Foundation

struct Shop: Decodable {
    let access: String
    let address: String
    let genre: Genre
    let lat: Double
    let lng: Double
    let name: String
    let open: String
    let photo: Photo
}
