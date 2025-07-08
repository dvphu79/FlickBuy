//
//  SignInScreen.swift
//  FlickBuyApp
//
//  Created by Phu DO on 3/7/25.
//

import SwiftUI

struct SignInScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = "vana@vnn.vn"
    @State private var password = "12345678"

    var body: some View {
        VStack(spacing: 20) {
            Text("FlickBuy")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            if let error = authViewModel.error {
                Text(error)
                    .foregroundColor(.red)
            }

            Button(action: {
                authViewModel.signIn(email: email, password: password)
            }, label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            })
        }
        .padding()
    }
}

#Preview {
    SignInScreen()
        .environmentObject(AuthViewModel())
}
