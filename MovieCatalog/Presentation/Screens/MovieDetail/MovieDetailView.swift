//
//  MovieDetailView.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 20.09.26.
//
import SwiftUI
import Kingfisher


struct MovieDetailView: View {
    
    @State private var viewModel : MovieDetailViewModel
    @State private var selectedTab: DetailTab = .about
    
    
    enum DetailTab:String ,CaseIterable {
        case about = "About Movie"
        case reviews = "Reviews"
        case cast = "Cast"
    }
    
    // Gelecekde test dependencyler ile test edile biler
    init(
        movie:Movie,
        useCase: ManageWatchlistUseCaseProtocol? = nil,
        fetchGenresUseCase: FetchGenresUseCaseProtocol? = nil,
        fetchSimilarMoviesUseCase: FetchSimilarMoviesUseCaseProtocol? = nil,
        fetchCreditsUseCase:FetchCreditsUseCaseProtocol? = nil
    ){
        let useCase = useCase ?? DIContainer.shared.manageWatchListUseCase
        let fetchGenresUseCase = fetchGenresUseCase ?? DIContainer.shared.fetchGenreUseCase
        let fetchSimilarMoviesUseCase  = fetchSimilarMoviesUseCase ?? DIContainer.shared.fetchSimilarMoviesUseCase
        let fetchCreditsUseCase = fetchCreditsUseCase ?? DIContainer.shared.fetchCreditsUseCase
        
        _viewModel = State(
            initialValue: MovieDetailViewModel(
                movie: movie,
                useCase: useCase,
                fetchGenreUseCase: fetchGenresUseCase,
                fetchSimilarMoviesUseCase: fetchSimilarMoviesUseCase,
                fetchCreditsUseCase: fetchCreditsUseCase)
        )
        
    }
    
    
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 16)
            {
                ZStack (alignment: .bottomLeading){
                    KFImage(viewModel.movie.backdropUrl)
                        .placeholder {
                            AppTheme.secondaryBackground
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 240)
                        .clipped()
                    HStack (alignment: .bottom,spacing: 12){
                        KFImage(viewModel.movie.posterUrl)
                            .placeholder {
                                AppTheme.secondaryBackground
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90,height: 130)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 8)
                            )
                        VStack (alignment: .leading, spacing: 4) {
                            Text(viewModel.movie.title)
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                            
                            RatingBadge(rating: viewModel.movie.rating)
                        }
                        Spacer()
                    }
                    .padding()
                }
                
                
                
                HStack(spacing: 20) {
                    Label(viewModel.movie.releaseYear,systemImage: "calendar")
                    Label(viewModel.movie.runtimeText,systemImage: "clock")
                    Label(viewModel.genreText,systemImage: "theatermasks")
                }
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
                .padding(.horizontal)
                
                HStack(spacing:24){
                    ForEach(DetailTab.allCases, id: \.self){ tab in
                        Button {
                            selectedTab = tab
                        } label : {
                            VStack{
                                Text(tab.rawValue)
                                    .font(
                                        .subheadline.weight(
                                            selectedTab == tab
                                            ?.semibold
                                            : .regular
                                        )
                                    )
                                    .foregroundStyle(
                                        selectedTab == tab
                                        ? AppTheme.primaryText
                                        : AppTheme.secondaryText
                                    )
                                Rectangle()
                                    .fill(
                                        selectedTab == tab
                                        ? AppTheme.primaryText
                                        : .clear
                                    )
                                    .frame(height:2)
                            }
                        }.buttonStyle(.plain)
                        
                    }
                }
                .padding(.horizontal)
                
                tabContent
                    .padding(.horizontal)
                    .padding(.bottom, 24)
            }
        }
        .background(AppTheme.background)
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Button {
                    viewModel.toogleBookmark()
                } label: {
                    Image(
                        systemName:
                            viewModel.isSaved
                        ? "bookmark.fill"
                        : "bookmark"
                    )
                    .foregroundStyle(
                        viewModel.isSaved
                        ? AppTheme.accent
                        : AppTheme.primaryText
                    )
                }
            }
        }
        .task {
            await viewModel.loadDetails()
        }
    }
    
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .about:
            aboutContent
        case .reviews:
            ContentUnavailableView(
                "Rəy yoxdur",
                systemImage: "text.bubble"
            )
        case .cast:
            castContent
        }
    }
    
    
    
    @ViewBuilder
    private var aboutContent: some View {
        VStack(alignment: .leading,spacing: 24) {
            VStack(alignment: .leading,spacing: 8) {
                Text("Overview")
                    .font(.title3.bold())
                    .foregroundStyle(AppTheme.primaryText)
                
                Text(
                    viewModel.movie.overview
                )
                .font(.body)
                .foregroundStyle(AppTheme.primaryText)
                .fixedSize(horizontal: false,vertical: true)
            }
            similarMoviesContent
        }
    }
    
    
    
    @ViewBuilder
    private var similarMoviesContent: some View {
        switch viewModel.similarMoviesState {
        case .idle:
            EmptyView()
            
        case .loading:
            VStack(alignment: .leading,spacing: 12) {
                Text("Similar Movies")
                    .font(.title3.bold())
                    .foregroundStyle(AppTheme.primaryText)
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical, 20)
            }
        case let .loaded(movies,_,_):
            similarMoviesList(
                movies: movies,
                isLoadingMore: false
            )
        case let .loadingMore(movies,_):
            similarMoviesList(
                movies: movies,
                isLoadingMore: true
            )
        case let .error(movies,_):
            if movies.isEmpty {
                ContentUnavailableView(
                    "Similar movies tapılmadı",
                    systemImage: "film"
                )
            } else {
                similarMoviesList(
                    movies: movies,
                    isLoadingMore: false
                )
            }
        }
    }
    
    @ViewBuilder
    private func similarMoviesList(
        movies: [Movie],
        isLoadingMore: Bool
    ) -> some View {
        VStack(alignment: .leading,spacing: 12) {
            Text("Similar Movies")
                .font(.title3.bold())
                .foregroundStyle(AppTheme.primaryText)
            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {
                LazyHStack(spacing: 12) {
                    ForEach(movies) { movie in
                        NavigationLink(value: movie) {
                            MoviePosterCard(movie: movie)
                        }
                    }
                    if isLoadingMore {
                        ProgressView()
                            .frame(width: 40)
                            .padding(.leading, 4)
                    }
                }
            }
        }
    }
    
    
    @ViewBuilder
    private var castContent: some View {
        switch viewModel.creditsState {
        case .idle:
            EmptyView()
        case .loading:
            VStack(spacing: 12) {
                ProgressView()
                Text(
                    "Aktyor məlumatları yüklənir..."
                )
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
        case let .loaded(director,cast):
            VStack(alignment: .leading,spacing: 24) {
                if let director {
                    directorContent(director)
                }
                
                if !cast.isEmpty {
                    castList(cast)
                    
                } else {
                    ContentUnavailableView(
                        "Aktyor məlumatı yoxdur",
                        systemImage: "person.2"
                    )
                }
            }
            
        case .error:
            ContentUnavailableView(
                "Credits yüklənmədi",
                systemImage: "person.2.slash"
            )
        }
    }
    
    
    
    
    
    @ViewBuilder
    private func castList(
        _ cast: [CastMember]
    ) -> some View {
        VStack(alignment: .leading,spacing: 12) {
            Text("Cast")
                .font(.title3.bold())
                .foregroundStyle(AppTheme.primaryText)
            
            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {
                LazyHStack(
                    alignment: .top,
                    spacing: 16
                ) {
                    ForEach(cast) { member in
                        castCard(
                            member
                        )
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func directorContent(
        _ director: CrewMember
    ) -> some View {
        VStack(alignment: .leading,spacing: 8) {
            Text("Director")
                .font(.title3.bold())
                .foregroundStyle(AppTheme.primaryText)
            HStack(spacing: 12) {
                
                KFImage(director.profileURL)
                    .placeholder {
                        ZStack {
                            AppTheme.secondaryBackground
                            
                            Image(systemName: "person.fill")
                                .font(.title2)
                                .foregroundStyle(AppTheme.secondaryText)
                        }
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80,height: 80)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                
                VStack(alignment: .leading,spacing: 3) {
                    
                    Text(director.name)
                        .font(.subheadline.bold())
                        .foregroundStyle(AppTheme.primaryText)
                    
                    Text("Director")
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondaryText)
                }
                
                Spacer()
            }
        }
    }
    @ViewBuilder
    private func castCard(
        _ member: CastMember
    ) -> some View {
        VStack(spacing: 8) {
            KFImage(member.profileURL)
                .placeholder {
                    ZStack {
                        AppTheme.secondaryBackground
                        
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80,height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(member.name)
                .font(.caption.bold())
                .foregroundStyle(AppTheme.primaryText)
                .lineLimit(1)
            
            Text(member.character)
                .font(.caption2)
                .foregroundStyle(AppTheme.secondaryText)
                .lineLimit(1)
        }
        .frame(width: 90)
    }
}

