//
//  MovieDetailViewModel.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 20.09.26.
//
import SwiftUI
import Observation


@MainActor
@Observable
final class MovieDetailViewModel {

    private(set) var  movie: Movie
    private(set) var isSaved: Bool = false
    private(set) var genreText: String = "-"
    private(set) var similarMoviesState: SimilarMoviesState = .idle
    
    // 4 element qalmis sorgu atir son elemente catanda artiq davami birlesmis formada gelir
    private let similarPrefetchThehold = 4
    private(set) var creditsState: CreditsState = .idle

    private let useCase: ManageWatchlistUseCaseProtocol

    private let fetchGenreUseCase: FetchGenresUseCaseProtocol

    private let fetchSimilarMoviesUseCase:
        FetchSimilarMoviesUseCaseProtocol

    private let fetchCredentialUseCase:
        FetchCreditsUseCaseProtocol


    init(
        movie: Movie,
        useCase: ManageWatchlistUseCaseProtocol,
        fetchGenreUseCase: FetchGenresUseCaseProtocol,
        fetchSimilarMoviesUseCase: FetchSimilarMoviesUseCaseProtocol,
        fetchCredentialUseCase: FetchCreditsUseCaseProtocol
    ) {
        self.movie = movie
        self.useCase = useCase
        self.fetchGenreUseCase = fetchGenreUseCase
        self.fetchSimilarMoviesUseCase =
            fetchSimilarMoviesUseCase
        self.fetchCredentialUseCase =
            fetchCredentialUseCase
    }
    
    func checkIfSavedMovie() async {
        isSaved = await useCase.isSaved(movieId: movie.id)
    }
 
    
    func toogleBookmark(){
        Task {
            do {
                try await useCase.toggle(movie: movie)
                isSaved.toggle()
            }catch {
                print("Toggle bookmark failed")
            }
        }
    }
    
    func loadGenreText() async {
        let genres = (try? await fetchGenreUseCase.execute()) ?? []
        genreText = movie.genreNames(from: genres)
    }



    
    func loadInitialSimilarMovies() async {
        guard case .idle = similarMoviesState else {
            return
        }
        similarMoviesState = .loading
        
        do {
            let response = try await fetchSimilarMoviesUseCase.execute(id: movie.id, page: 1)
            similarMoviesState = .loaded(movies: response.movies, currentPage: 1, hasMore: !response.movies.isEmpty)
        }catch {
            similarMoviesState = .error(movies: [], message: error.localizedDescription)
        }

    }



    func loadNextSimilarPageIfNeeded(
        currentItem movie:Movie
    )async {
        guard case let .loaded (
            movies,
            currentPage,
            hasMore
        ) = similarMoviesState else { return}
        
        guard hasMore else {
            return
        }
        guard let index = movies.firstIndex(where: {$0.id == movie.id}) else { return }
        let theHoldIndex = max (movies.count - similarPrefetchThehold , 0)
        guard index >= theHoldIndex else { return }
        await loadSimilarPage(page: currentPage+1, existingMovies: movies)
        
        
    }

    
    private func loadSimilarPage(
        page:Int,
        existingMovies:[Movie]
    )async {
        similarMoviesState = .loadingMore(movies: existingMovies, currentPage: page-1)
        
        do {
            let movieResult = try await fetchSimilarMoviesUseCase.execute(id: movie.id, page: page)
            let updatedMovies = existingMovies + movieResult.movies
            similarMoviesState = .loaded(movies: updatedMovies, currentPage: page, hasMore: !movieResult.movies.isEmpty)
        }catch {
            similarMoviesState = .error(movies: existingMovies, message: error.localizedDescription)
        }
    }



    
    func loadCredits() async {
        guard case .idle = creditsState else {
            return
        }
        creditsState = .loading
        do {
            let credits = try await fetchCredentialUseCase.execute(movieId: movie.id)
            let director = credits.director
            creditsState = .loaded(director: director, cast: credits.cast)
        }catch {
            creditsState = .error
        }
    }
    
    func selectSimilarMovie (_ movie:Movie) async {
        self.movie = movie
        isSaved = false
        genreText = ""
        similarMoviesState = .idle
        creditsState = .idle
        await loadDetails()
        
    }



    // Paralel baslatmaq
    func loadDetails() async {
        async let saved: () = checkIfSavedMovie()
        async let genre: () = loadGenreText()
        async let similar:() = loadInitialSimilarMovies()
        async let credits: () = loadCredits()
        
        let allResults = await (saved,genre,similar,credits)
    }
   
}

