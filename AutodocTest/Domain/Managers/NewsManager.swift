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
    private var nextPage: Int = 1

    private var news: [News] = []
    private var newsIds: Set<News.ID> = []

    init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
        self.pageSize = 15
    }
}

// MARK: - NewsManagerProtocol
extension NewsManager: NewsManagerProtocol {    
    var hasMoreNews: Bool {
        guard let totalCount else { return true }
        return (nextPage - 1) * pageSize < totalCount
    }

    func fetchNewsPage() async throws {
        guard hasMoreNews else { return }

        let dto = try await fetchPage()
        let mappedNews = mapNews(dto)
        self.news.append(contentsOf: mappedNews)
    }

    func getAllNews() -> [News] {
        return news
    }
}

// MARK: - Private
private extension NewsManager {
    func fetchPage() async throws -> NewsListDTO {
        let dto = try await networkClient.sendRequest(GetNewsListEndpoint(page: nextPage, maxItems: pageSize), type: NewsListDTO.self)
        return dto
    }

    func mapNews(_ dto: NewsListDTO) -> [News] {
        totalCount = dto.totalCount ?? pageSize
        nextPage += 1

        var newsModel: [News] = []

        for item in dto.news {
            guard !newsIds.contains(item.id) else { continue }

            let news = News(dto: item)
            newsModel.append(news)
            newsIds.insert(news.id)
        }
        return newsModel
    }
}
