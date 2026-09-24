//
//  FilterChipsView.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 20.09.26.
//
import SwiftUI

struct FilterChipsView: View {
    let genres: [Genre]
    let years: [Int]
    @Binding var selectedGenre: Genre?
    @Binding var selectedYear: Int?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                HStack {
                    ForEach(genres) { genre in
                        chip(
                            title: genre.name,
                            isSelected: selectedGenre == genre
                        ) {
                            selectedGenre = (selectedGenre == genre) ? nil : genre
                        }
                        
                    }
                }
                Divider().frame(height: 20)
                HStack {
                   

                    ForEach(years, id: \.self) { year in
                        chip(
                            title: "\(year)",
                            isSelected: selectedYear == year
                        ) {
                            selectedYear = (selectedYear == year) ? nil : year
                        }
                    }
                }
               
            
               
            }
            .padding(.horizontal)
        }
    }

    private func chip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? AppTheme.accent : AppTheme.cardBackground)
                .foregroundStyle(isSelected ? .white : AppTheme.primaryText)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}


