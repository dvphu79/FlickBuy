//
//  HomeTabView.swift
//  FlickBuy
//
//  Created by Phu DO on 3/7/25.
//

import SwiftUI

struct HomeTabView: View {
    @StateObject private var viewModel = HomeViewModel()

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.products) { product in
                            ProductCardView(product: product)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("FlickBuy")
            .onAppear {
                viewModel.fetchProducts()
            }
        }
    }
}