//
//  AuthViewModel.swift
//  FlickBuyApp
//
//  Created by Phu DO on 3/7/25.
//

import Foundation
import Appwrite

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var error: String?

    private let appwriteService = AppwriteService.shared

    init() {
        checkSession()
    }

    func checkSession() {
        Task {
            do {
                _ = try await appwriteService.account.get()
                self.isLoggedIn = true
            } catch {
                self.isLoggedIn = false
            }
        }
    }

    func signIn(email: String, password: String) {
        Task {
            do {
                _ = try await appwriteService.account.createEmailPasswordSession(email: email, password: password)
                self.isLoggedIn = true
                self.error = nil
            } catch {
                self.isLoggedIn = false
                self.error = error.localizedDescription
            }
        }
    }

    func signOut() {
        Task {
            do {
                _ = try await appwriteService.account.deleteSession(sessionId: "current")
                self.isLoggedIn = false
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}