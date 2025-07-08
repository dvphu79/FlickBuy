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
    @Published var currentUser: AppUser?
    @Published var error: String?

    private let appwriteService: AppwriteServiceProtocol

    init(appwriteService: AppwriteServiceProtocol = AppwriteService.shared) {
        self.appwriteService = appwriteService
        checkSession()
    }

    func checkSession() {
        Task {
            do {
                let user = try await appwriteService.account.get()
                self.isLoggedIn = true
                self.currentUser = AppUser(uid: user.id, email: user.email, createdAt: user.createdAt)
            } catch {
                self.isLoggedIn = false
            }
        }
    }

    func signIn(email: String, password: String) {
        Task {
            do {
                let session = try await appwriteService.account.createEmailPasswordSession(email: email, password: password)
                self.isLoggedIn = true
                self.currentUser = AppUser(uid: session.userId, email: session.providerUid, createdAt: session.createdAt)
                self.error = nil
            } catch {
                self.isLoggedIn = false
                self.error = error.localizedDescription
            }
        }
    }
    
    // TODO: resolve later.
    func logIn(email: String, password: String) {
        Task {
            do {
                _ = try await appwriteService.account.createEmailPasswordSession(email: email, password: password)
                // TODO: resolve later.
                let user = try await appwriteService.account.get()
                self.isLoggedIn = true
                self.currentUser = AppUser(uid: user.id, email: user.email, createdAt: user.createdAt)
                self.error = nil
            } catch let error as AppwriteError {
                // TODO: resolve later.
                if let errorType = error.type, errorType == "general_unauthorized_scope", error.code == 401 {
                    self.isLoggedIn = true
                    self.currentUser = AppUser(uid: "", email: nil, createdAt: nil)
                    self.error = nil
                    return
                }
                self.isLoggedIn = false
                self.error = error.localizedDescription
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
                self.currentUser = nil
                self.isLoggedIn = false
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}
