import SwiftUI

struct HomeView: View {
    @State private var movies: [Movie] = []
    @State private var loading = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Cinejoy")
                        .font(.largeTitle.bold())

                    Text("Trending")
                        .font(.title2.bold())

                    if loading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else if movies.isEmpty {
                        Text("No movies available.")
                            .foregroundStyle(.secondary)
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 120), spacing: 14)
                            ],
                            spacing: 18
                        ) {
                            ForEach(movies) { movie in
                                VStack(alignment: .leading, spacing: 6) {
                                    AsyncImage(
                                        url: URL(
                                            string:
                                                "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"
                                        )
                                    ) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Rectangle()
                                            .fill(.secondary.opacity(0.2))
                                    }
                                    .frame(height: 180)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 10)
                                    )

                                    Text(movie.title)
                                        .font(.headline)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .task {
                do {
                    movies = try await TMDBService.shared.trending()
                } catch {
                    movies = []
                }
                loading = false
            }
        }
    }
}
