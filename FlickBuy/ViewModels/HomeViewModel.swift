//
//  HomeViewModel.swift
//  FlickBuy
//
//  Created by Phu DO on 3/7/25.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var error: String?
    @Published var isLoading = false

    private let appwriteService: AppwriteServiceProtocol

    init(appwriteService: AppwriteServiceProtocol = AppwriteService.shared) {
        self.appwriteService = appwriteService
    }

    func fetchProducts() {
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                products = try await appwriteService.fetchProducts()
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}