//
//  Config.swift
//  FlickBuy
//

import Foundation

struct Config {
    static let shared = Config()

    let appwriteEndpoint: String
    let appwriteProjectId: String
    let appwriteDatabaseId: String
    let appwriteProductCollectionId: String

    private init() {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let configDict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("Config.plist not found or is invalid.")
        }

        guard let endpoint = configDict["AppwriteEndpoint"] as? String,
              let projectId = configDict["AppwriteProjectId"] as? String,
              let databaseId = configDict["AppwriteDatabaseId"] as? String,
              let productCollectionId = configDict["AppwriteProductCollectionId"] as? String else {
            fatalError("One or more configuration keys are missing from Config.plist.")
        }

        self.appwriteEndpoint = endpoint
        self.appwriteProjectId = projectId
        self.appwriteDatabaseId = databaseId
        self.appwriteProductCollectionId = productCollectionId
    }
}