//  Created by Phu DO on 3/7/25.
//
//

import SwiftUI
import Appwrite

struct ProfileTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            if let user = authViewModel.currentUser {
                Form {
                    Section(header: Text("User Information")) {
                        HStack {
                            Text("User ID")
                            Spacer()
                            Text(user.uid)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(user.email ?? "")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Joined")
                            Spacer()
                            Text(user.createdAt ?? "")
                                .foregroundColor(.secondary)
                        }
                    }

                    Section {
                        Button(role: .destructive, action: {
                            authViewModel.signOut()
                        }) {
                            Text("Sign Out")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .navigationTitle("Profile")
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    ProfileTabView()
        .environmentObject(AuthViewModel())
}
