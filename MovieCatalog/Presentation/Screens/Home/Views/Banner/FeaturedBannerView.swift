//
//  FeaturedBannerView.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import SwiftUI
import Kingfisher

struct FeaturedBannerView: View {
    
    
    let state: SectionState
    var onRetry: (() -> Void)? = nil
    
    var body: some View {
        
        switch state {
        case .idle, .loading:
            loadingPlaceholder
            
        case .success(let movies):
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                        NavigationLink(value: movie) {
                            ZStack(alignment: .bottomLeading) {
                                KFImage(movie.posterUrl)
                                    .placeholder {
                                        AppTheme.secondaryBackground
                                    }
                                    .resizable()
                                    .fade(duration: 0.25)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 220)
                                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                                
                                
                            }
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
