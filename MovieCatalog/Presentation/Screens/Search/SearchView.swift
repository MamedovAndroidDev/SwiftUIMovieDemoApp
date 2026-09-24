//
//  SearchView.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import SwiftUI

struct SearchView :View {
    @State private var viewModel : SearchViewModel
    @FocusState private var isSearchFocused:Bool
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    init(viewModel: SearchViewModel) {
        _viewModel = State(initialValue: viewModel)
        
        self.isSearchFocused = isSearchFocused
    }
    var body: some View {
        VStack (spacing:0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(AppTheme.secondaryText)
                TextField("Search movies...",text: $viewModel.searchText)
                    .focused($isSearchFocused)
                    .textFieldStyle(.plain)
                    .foregroundStyle(AppTheme.primaryText)
                if !viewModel.searchText.isEmpty{
                    Button {
                        viewModel.searchText = ""
                    }label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
            }
            .padding(12)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .padding(.top, 8)
            
            FilterChipsView(
                genres: viewModel.availableGenres,
                years: viewModel.availableYears,
                selectedGenre: $viewModel.selectedGenre,
                selectedYear: $viewModel.selectedYear
            )
            .padding(.top, 12)
            
            if viewModel.selectedGenre != nil || viewModel.selectedYear != nil {
                HStack {
                    Spacer()
                    Button("Filterleri sifirla"){
                        viewModel.clearFilters()
                    }
                    .font(.caption)
                    .foregroundStyle(AppTheme.accent)
                    .padding(.trailing)
                }
                .padding(.top,4)
            }
            content
                .frame(maxHeight: .infinity)
        }
        .background(AppTheme.background)
        .task {
            await viewModel.loadGenres()
        }
        .onDisappear {
             viewModel.cancelSearch()
        }
        .navigationDestination(for: Movie.self) { movie in
           MovieDetailView(movie: movie)
        }
    }
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView(
                "Axtarışa başla",
                systemImage: "magnifyingglass",
                description: Text("Film adı yaz və ya filter seç")
            )

        case .loading:
            ProgressView()
                .padding(.top, 40)

        case .success(let movies):
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink(value: movie) {
                            MoviePosterCard(movie: movie)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }

        case .empty:
            ContentUnavailableView(
                "Nəticə tapılmadı",
                systemImage: "film",
                description: Text("Axtarış şərtlərinə uyğun film yoxdur")
            )

        case .error(let message):
            ContentUnavailableView {
                Label("Xəta baş verdi", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Yenidən cəhd et") {
                    viewModel.retry()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}




   
#Preview("Success") {
    NavigationStack {
        SearchView(viewModel: {
            let vm = SearchViewModel(
                useCase: PreviewSearchUseCase(result: .success(Movie.mockList)),
                fetchGenresUseCase: PreviewFetchGenresUseCase()
            )
            vm.searchText = "Spider"
            return vm
        }())
    }
}

#Preview("Empty") {
    NavigationStack {
        SearchView(viewModel: {
            let vm = SearchViewModel(
                useCase: PreviewSearchUseCase(result: .success([])),
                fetchGenresUseCase: PreviewFetchGenresUseCase()
            )
            vm.searchText = "xyz123"
            return vm
        }())
    }
}

#Preview("Error") {
    NavigationStack {
        SearchView(viewModel: {
            let vm = SearchViewModel(
                useCase: PreviewSearchUseCase(result: .failure(NetworkError.noInternetConnection)),
                fetchGenresUseCase: PreviewFetchGenresUseCase()
            )
            vm.searchText = "Batman"
            return vm
        }())
    }
}

#Preview("Idle") {
    NavigationStack {
        SearchView(viewModel: SearchViewModel(
            useCase: PreviewSearchUseCase(result: .success([])),
            fetchGenresUseCase: PreviewFetchGenresUseCase()
        ))
    }
}
