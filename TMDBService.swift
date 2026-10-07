import Foundation

final class TMDBService {
    static let shared = TMDBService()
    private let baseURL = "https://api.themoviedb.org/3"

    var apiKey: String {
        ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? ""
    }

    func trending() async throws -> [Movie] {
        guard !apiKey.isEmpty else { return [] }

        var components = URLComponents(
            string: baseURL + "/trending/movie/week"
        )!

        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]

        let (data, response) =
            try await URLSession.shared.data(from: components.url!)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        struct Response: Codable {
            let results: [Movie]
        }

        return try JSONDecoder()
            .decode(Response.self, from: data)
            .results
    }
}
