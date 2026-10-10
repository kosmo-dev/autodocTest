//
//  NewsManager.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

@MainActor
final class NewsManager {
    private let networkClient: NetworkRouting

    private let pageSize: Int
    private var totalCount: Int?

    private var news: [News] = []

    init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
        self.pageSize = 15
    }
}

// MARK: - NewsManagerProtocol
extension NewsManager: NewsManagerProtocol {
    var hasMoreNews: Bool {
        guard let totalCount else { return true }
        return news.count < totalCount
    }

    func fetchNewsPage() async throws {
        guard hasMoreNews else { return }

        let dto = try await fetchPage(from: news.count)
        totalCount = dto.totalCount ?? pageSize

        let news = dto.news.map { News(dto: $0) }
        self.news.append(contentsOf: news)
    }

    func getNews() -> [News] {
        return news
    }
}

// MARK: - Private
private extension NewsManager {
    func fetchPage(from offset: Int) async throws -> NewsListDTO {
        let to: Int

        if let totalCount {
            to = min(totalCount, offset + pageSize)
        } else {
            to = offset + pageSize
        }

        let dto = try await networkClient.sendRequest(GetNewsListEndpoint(from: offset, to: to), type: NewsListDTO.self)
        return dto
    }
}
