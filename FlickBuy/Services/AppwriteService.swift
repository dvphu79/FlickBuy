//
//  AppwriteService.swift
//  FlickBuyApp
//
//  Created by Phu DO on 3/7/25.
//

import Appwrite
import Foundation

class AppwriteService {
    static let shared = AppwriteService()

    let client: Client
    let account: Account

    private init() {
        client = Client()
            .setEndpoint("https://fra.cloud.appwrite.io/v1") // Your Appwrite Endpoint
            .setProject("68413fe7001941b40808") // Your project ID
        account = Account(client)
    }
}
