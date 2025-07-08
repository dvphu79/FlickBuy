//
//  ProductCardView.swift
//  FlickBuy
//
//  Created by Phu DO on 3/7/25.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageUrl = product.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    // Placeholder while the image is loading
                    ZStack {
                        Color(.secondarySystemBackground)
                        ProgressView()
                    }
                }
                .frame(height: 150)
                .cornerRadius(10)
            } else {
                // Placeholder for when there is no image URL
                ImagePlaceholderView()
                    .frame(height: 150)
                    .cornerRadius(10)
            }
            
            Text(product.name)
                .font(.headline)
            
            Text(product.price, format: .currency(code: "USD"))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
