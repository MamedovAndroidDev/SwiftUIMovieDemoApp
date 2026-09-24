//
//  RatingBadge.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 20.09.26.
//
import SwiftUI

struct RatingBadge: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(AppTheme.starColor)
            Text(String(format: "%.1f", rating))
                .foregroundStyle(AppTheme.starColor)
        }
        .font(.caption.weight(.semibold))
    }
}

#Preview {
    RatingBadge(rating: 9.5)
        .padding()
        .background(AppTheme.background)
}
