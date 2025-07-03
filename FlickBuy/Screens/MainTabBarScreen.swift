//
//  MainTabBarScreen.swift
//  FlickBuy
//
//  Created by Phu DO on 3/7/25.
//

import SwiftUI

struct MainTabBarScreen: View {
    var body: some View {
        TabView {
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ProfileTabView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainTabBarScreen()
        .environmentObject(AuthViewModel())
}