//
//  NewsListViewModel.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 10.10.2026.
//

import Foundation
import Combine

protocol NewsListViewModelDelegate: AnyObject {
    func didSelectNews(_ urlString: String)
}

@MainActor
final class NewsListViewModel: ObservableObject {
    weak var delegate: NewsListViewModelDelegate?

    @Published private(set) var news: [News] = []

    @Published private(set) var loaderState: LoaderState = .loading

    private var newsManager: NewsManagerProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var fetchTask: Task<Void, Error>?

    init(newsManager: NewsManagerProtocol) {
        self.newsManager = newsManager
    }

    func fetchNextPage() {
        guard fetchTask == nil else { return }

        loaderState = .loading
        fetchTask = Task {
            defer { fetchTask = nil }

            do {
                try await newsManager.fetchNewsPage()
                self.loaderState = newsManager.hasMoreNews ? .loading : .empty
                self.news = newsManager.getAllNews()
            } catch {
                guard !Task.isCancelled else { return }
                loaderState = .error
            }
        }
    }

    func showDetailNews(_ id: Int) {
        guard let news = news.first(where: { $0.id == id }) else { return }
        delegate?.didSelectNews(news.fullUrl)
    }
}
