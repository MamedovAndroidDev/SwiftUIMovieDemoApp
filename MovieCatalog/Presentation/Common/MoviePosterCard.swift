//
//  MoviePosterCard.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import SwiftUI

import SwiftUI

import SwiftUI
import SDWebImageSwiftUI

struct MoviePosterCard: View {

    let movie: Movie

    var width: CGFloat = 120
    var height: CGFloat = 170

    private let titleHeight: CGFloat = 34
    private let ratingHeight: CGFloat = 16

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

         

            WebImage(url: movie.posterUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    AppTheme.cardBackground

                    ProgressView()
                }
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.25))
            .frame(width: width, height: height)
            .clipped()
            .background(AppTheme.cardBackground)
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )

     

            Text(movie.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(AppTheme.primaryText)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(
                    width: width,
                    height: titleHeight,
                    alignment: .topLeading
                )

     

            HStack(spacing: 3) {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundStyle(.yellow)

                Text(String(format: "%.1f", movie.rating))
                    .font(.caption2)
                    .foregroundStyle(AppTheme.secondaryText)
            }
            .frame(
                width: width,
                height: ratingHeight,
                alignment: .leading
            )
        }
        .frame(width: width)
    }
}
