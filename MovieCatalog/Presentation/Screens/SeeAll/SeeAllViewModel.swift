//
//  SeeAllViewModel.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 21.09.26.
//
import Observation


@MainActor
@Observable
final class SeeAllViewModel {
    
    var movies:[Movie] = []
    var state: ListState = .idle
    var isLoadingNextPage = false
    let category: MovieCategory
    private let useCase: FetchMoviesUseCaseProtocol
    private var currentPage = 0
    private var totalPages = 1
    private var canLoadMore: Bool {
        currentPage < totalPages
    }
    private var loadTask : Task<Void,Never>?
    
    init(category:MovieCategory, useCase:FetchMoviesUseCaseProtocol){
        self.category = category
        self.useCase = useCase
    }
    
    func loadFirstPage() async {
        guard case .idle = state else {
            return
        }
        await reload()

    }
    
    func reload() async {
        loadTask?.cancel()
        loadTask = nil
        isLoadingNextPage = false
        currentPage = 0
        totalPages = 1
        movies.removeAll()
        state = .loading
        do {
            let response = try await useCase.execute(category: category, page: 1)
            guard !Task.isCancelled else {
                return
            }
            movies = response.movies
            currentPage = response.page
            totalPages = response.totalPages
            state = movies.isEmpty ? .empty : .success
            
        }
        catch {
            guard !Task.isCancelled else {
                return
            }
            state = .error(error.localizedDescription)
        }
    }
    
    func loadNextPageIfNeeded(currentItem:Movie){
        
        guard let index = movies.firstIndex(where: {$0.id == currentItem.id}) else {
            return
        }
        let prefetchhold = 4
        let thesholdIndex = max(movies.count - prefetchhold, 0)
        
        guard index >= thesholdIndex else {
            return
        }
        
        guard canLoadMore else {
            return
        }
        
        guard !isLoadingNextPage else {
            return
        }
        loadTask = Task {[weak self] in
           await self?.loadNextPage()
        }
    }
    
    private func loadNextPage() async {
        guard !isLoadingNextPage else {
            return
        }
        guard canLoadMore else {
            return
        }
        isLoadingNextPage = true
        
        defer {
            isLoadingNextPage = false
        }
        let nextPage = currentPage + 1
        do {
            let response = try await useCase.execute(category: category, page: nextPage)
            guard !Task.isCancelled else {
                return
            }
            let existIDs = Set(
                movies.map(\.id)
            )
            let newMovies = response.movies.filter {
                !existIDs.contains($0.id)
            }
            movies.append(contentsOf: newMovies)
            currentPage = response.page
            totalPages = response.totalPages
        }
        catch {
            guard !Task.isCancelled else {
                return
            }
            state = .error(error.localizedDescription)
        }
    }
    
    func cancelLoading() {
        loadTask?.cancel()
        loadTask = nil
    }
}

enum ListState {
    case idle
    case loading
    case success
    case empty
    case error(String)
}
