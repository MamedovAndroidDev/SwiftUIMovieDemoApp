//
//  RootTabView.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import SwiftUI

struct RootTabView:View {
    @State private var selectedTab  = 0
    var body: some View {
        TabView {
            NavigationStack {
                HomeView(viewModel: DIContainer.shared.makeHomeViewModel(),selectedTab: $selectedTab)
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(0)
            
            NavigationStack {
                SearchView(viewModel: DIContainer.shared.makeSearchViewModel())
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            .tag(1)
            
            NavigationStack {
                WatchListView(viewModel: DIContainer.shared.makeWatchListViewModel())
            }
            .tabItem { Label("Watch List", systemImage: "bookmark") }
            .tag(2)
        }
       
        .tint(AppTheme.accent)
    }
}



