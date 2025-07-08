//
//  AppwriteService.swift
//  FlickBuyApp
//
//  Created by Phu DO on 3/7/25.
//

import Appwrite
import Foundation

class AppwriteService: AppwriteServiceProtocol {
    static let shared = AppwriteService()

    let client: Client
    let account: Account
    let databases: Databases

    private let databaseId: String
    private let productCollectionId: String

    private init() {
        let config = Config.shared
        databaseId = config.appwriteDatabaseId
        productCollectionId = config.appwriteProductCollectionId
        client = Client()
            .setEndpoint(config.appwriteEndpoint)
            .setProject(config.appwriteProjectId)
        account = Account(client)
        databases = Databases(client)
    }

    func fetchProducts() async throws -> [Product] {
        let result = try await databases.listDocuments(
            databaseId: databaseId,
            collectionId: productCollectionId
        )

        let products: [Product] = result.documents.compactMap { document in
            do {
                // Re-encode the document and then decode it into our Product model.
                // This avoids a compiler ambiguity between the `data` property and the `data(to:)` method on the Document type.
                let documentData = try JSONEncoder().encode(document)
                return try JSONDecoder().decode(Product.self, from: documentData)
            } catch {
                print("Failed to decode product document: \(error)")
                return nil
            }
        }
        return products
    }
}
