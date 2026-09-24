//
//  SectionHeaderView.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 21.09.26.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let category: MovieCategory

    var body: some View {
        HStack {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(AppTheme.primaryText)

            Spacer()

            NavigationLink(value: category) {
                HStack(spacing: 4) {
                    Text("Hamısına bax")
                        .font(.subheadline)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                .foregroundStyle(AppTheme.secondaryText)
            }
        }
        .padding(.horizontal)
    }
}
