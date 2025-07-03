//
//  Product.swift
//  FlickBuy
//
//  Created by Phu DO on 3/7/25.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case name, description, price, imageUrl
    }
}