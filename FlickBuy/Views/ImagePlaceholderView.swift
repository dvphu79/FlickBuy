//
//  ImagePlaceholderView.swift
//  FlickBuy
//
//  Created by Phu DO on 3/7/25.
//

import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
            Image(systemName: "photo.on.rectangle.angled")
                .font(.largeTitle)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ImagePlaceholderView()
        .frame(width: 200, height: 150)
}