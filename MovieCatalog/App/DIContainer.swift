//
//  DIContainer.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

import SwiftData
@MainActor
final class DIContainer {
    static let shared = DIContainer()
    
    lazy var networkService: NetworkServiceProtocol = DefaultNetworkService()
    
    lazy var movieRepository: MovieRepositoryProtocol = MovieRepository(networkService: networkService)
    lazy var genreRepository: GenreRepositoryProtocol = GenreRepository(networkService: networkService)
    lazy var creditsRepository: CredentialRepositoryProtocol = CredentialRepository(networkService: networkService)
   
    
    lazy var fetchGenreUseCase : FetchGenresUseCaseProtocol = FetchGenresUseCase(repository: genreRepository)
    lazy var fetchMovieUseCase : FetchMoviesUseCaseProtocol = FetchMoviesUseCase(repository: movieRepository)
    lazy var fetchSimilarMoviesUseCase : FetchSimilarMoviesUseCase = FetchSimilarMoviesUseCase(repository: movieRepository)
    lazy var fetchCreditsUseCase : FetchCreditsUseCaseProtocol = FetchCreditsUseCase(repository: creditsRepository)
    lazy var searchMovieUseCase : SearchMoviesUseCaseProtocol = SearchMoviesUseCase(repository: movieRepository)
    
    lazy var modelContainer : ModelContainer =  {
        do {
          return try ModelContainer(for: MovieEntity.self)
        }catch{
            fatalError("ModelContainer yaradıla bilmədi: \(error)")
        }
    }()
    
    // Birbasa bilmir hansi watchlist gelecek. sadece protocol ve metodlari gorurur belelik abstraction kodda yaratmis olduq

  //  lazy var watchListRepository : WatchlistRepositoryProtocol = WatchlistRepository(context: modelContainer.mainContext)
    lazy var watchListRepository : WatchlistRepositoryProtocol = WatchListFileRepository()
    lazy var manageWatchListUseCase : ManageWatchlistUseCaseProtocol = ManageWatchlistUseCase(repository: watchListRepository)
    
    private init (){
        
    }
    func makeHomeViewModel() -> HomeViewModel{
        HomeViewModel(useCase: fetchMovieUseCase)
    }
    
    func makeSearchViewModel() -> SearchViewModel{
        SearchViewModel(useCase: searchMovieUseCase, fetchGenresUseCase: fetchGenreUseCase)
    }
    
    func makeWatchListViewModel() -> WatchListViewModel{
       WatchListViewModel(useCase: manageWatchListUseCase, fetchGenresUseCase: fetchGenreUseCase)
    }
}
