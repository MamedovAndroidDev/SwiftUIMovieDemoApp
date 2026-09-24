//
//  CarouselSectionView.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 21.09.26.
//

import SwiftUI

struct CarouselSectionView: View {
    let title: String
    let category: MovieCategory
    let state: SectionState
    var onRetry: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: title, category: category)

            switch state {
            case .idle, .loading:
                loadingPlaceholder

            case .success(let movies):
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(movies) { movie in
                            NavigationLink(value: movie) {
                                MoviePosterCard(movie: movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }

            case .empty:
                ContentUnavailableView(
                    "Film tapılmadı",
                    systemImage: "film",
                    description: Text("Bu kateqoriyada film yoxdur")
                )
                .padding(.horizontal)

            case .error(let message):
                
                ContentUnavailableView {
                    Label("Xəta baş verdi", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(message)
                } actions: {
                    if let onRetry {
                        Button("Yenidən cəhd et", action: onRetry)
                            .buttonStyle(.borderedProminent)
                    }
                    
                }
                .padding(.horizontal)
               
            }
        }
    }

    private var loadingPlaceholder: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppTheme.cardBackground)
                        .frame(width: 120, height: 170)
                }
            }
            .padding(.horizontal)
        }
        .redacted(reason: .placeholder)
    }
}
