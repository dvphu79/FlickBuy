//
//  AuthViewModel.swift
//  FlickBuyApp
//
//  Created by Phu DO on 3/7/25.
//

import Foundation
import Appwrite
import Security

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: AppUser?
    @Published var error: String?

    // Using a reverse-DNS style string is a good practice for keychain keys to avoid collisions.
    private let userEmailKey = "com.dvphu79.flickbuy.userEmail"
    private let userPasswordKey = "com.dvphu79.flickbuy.userPassword"

    private let appwriteService: AppwriteServiceProtocol

    init(appwriteService: AppwriteServiceProtocol = AppwriteService.shared) {
        self.appwriteService = appwriteService
        checkSession()
    }

    func checkSession() {
        Task {
            do {
                // Attempt to retrieve stored credentials from the Keychain.
                guard let email = retrieveStringFromKeychain(key: userEmailKey),
                      let password = retrieveStringFromKeychain(key: userPasswordKey) else {
                    // No credentials stored, so the user is not logged in.
                    self.isLoggedIn = false
                    return
                }
                self.signIn(email: email, password: password)
            } catch {
                self.isLoggedIn = false
            }
        }
    }

    func signIn(email: String, password: String) {
        Task {
            do {
                let session = try await appwriteService.account.createEmailPasswordSession(email: email, password: password)
                self.saveCredentials(email: email, password: password)
                self.isLoggedIn = true
                self.currentUser = AppUser(uid: session.userId, email: session.providerUid, createdAt: session.createdAt)
                self.error = nil
            } catch {
                self.isLoggedIn = false
                self.error = error.localizedDescription
                // On failure, ensure any stored credentials are removed.
                self.clearCredentials()
            }
        }
    }

    func signOut() {
        Task {
            do {
                self.clearCredentials()
                self.currentUser = nil
                self.isLoggedIn = false
            } catch {
                print("sign out error: \(error.localizedDescription)")
                self.error = error.localizedDescription
            }
        }
    }
    
    // MARK: - Keychain Management

    private func saveCredentials(email: String, password: String) {
        guard let passwordData = password.data(using: .utf8) else {
            print("Error: Could not encode password to data.")
            return
        }

        // It's safer to delete any existing item before adding a new one.
        deleteKeychainItem(for: userPasswordKey)
        deleteKeychainItem(for: userEmailKey)

        saveToKeychain(key: userEmailKey, value: email)
        saveToKeychain(key: userPasswordKey, data: passwordData)
    }

    private func clearCredentials() {
        deleteKeychainItem(for: userEmailKey)
        deleteKeychainItem(for: userPasswordKey)
    }

    private func saveToKeychain(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        saveToKeychain(key: key, data: data)
    }

    private func saveToKeychain(key: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            // Make the item accessible only when the device is unlocked.
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            // This can happen if the item already exists, which we handle by deleting first.
            // If it still fails, it's worth logging.
            print("Error saving to keychain: \(status)")
        }
    }

    private func deleteKeychainItem(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            // We don't need to log errSecItemNotFound, as that's an expected state when clearing.
            print("Error deleting from keychain: \(status)")
        }
    }

     private func retrieveStringFromKeychain(key: String) -> String? {
        guard let data = retrieveFromKeychain(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func retrieveFromKeychain(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            if status != errSecItemNotFound {
                // We don't need to log errSecItemNotFound, as that's an expected state.
                print("Error retrieving from keychain: \(status)")
            }
            return nil
        }
    }
}
