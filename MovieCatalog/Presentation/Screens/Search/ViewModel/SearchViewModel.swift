//
//  SearchViewModel.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import Observation
import Foundation


@Observable
@MainActor
final class SearchViewModel  {
    
    private(set) var state:State = .idle
    private let useCase: SearchMoviesUseCaseProtocol
    private let fetchGenresUseCase: FetchGenresUseCaseProtocol
    private var searchTask : Task<Void,Never>?
    
    var selectedGenre : Genre? {
        didSet {
            search()
        }
    }
    var selectedYear : Int? {
        didSet {
            search()
        }
    }
    
    var searchText : String = ""{
        didSet {
            search()
        }
    }
    private(set) var availableGenres : [Genre] = []
    let availableYears : [Int] = Array(2010...2026).reversed()
    
    
    
    
    
    init(useCase: SearchMoviesUseCaseProtocol,fetchGenresUseCase: FetchGenresUseCaseProtocol) {
        self.useCase = useCase
        self.fetchGenresUseCase = fetchGenresUseCase
    }
    
    func search(){
        cancelSearch()
        
        guard !searchText.isEmpty || selectedGenre != nil || selectedYear != nil else {
            state = .idle
            return
        }
        
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else { return }
            state = .loading
            do {
                let movies = try await useCase.execute(query: searchText, genreId: selectedGenre?.id, year: selectedYear)
                guard !Task.isCancelled else { return }
                state = movies.isEmpty ? .empty : .success(movies)
            }
            catch   is CancellationError {
                
            }
            
            catch {
                guard !Task.isCancelled else {return }
                let message = (error as? LocalizedError)?.errorDescription ?? "Bilinmeyen xeta"
                state = .error(message)
            }
        }
    }
    func retry(){
        search()
    }
    
    func cancelSearch(){
        searchTask?.cancel()
    }
    func loadGenres() async{
        guard availableGenres.isEmpty else {return}
        availableGenres = await ( try? fetchGenresUseCase.execute())  ?? []
    }
    
    func clearFilters(){
        selectedYear = nil
        selectedGenre = nil
    }
    
    
    enum State {
        case idle
        case loading
        case success ([Movie])
        case empty
        case error(String)
    }
}


