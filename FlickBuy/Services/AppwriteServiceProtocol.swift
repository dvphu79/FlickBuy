//
//  AppwriteServiceProtocol.swift
//  FlickBuy
//
//  Created by Phu DO on 3/7/25.
//

import Foundation
import Appwrite

protocol AppwriteServiceProtocol {
    var account: Account { get }
    func fetchProducts() async throws -> [Product]
}