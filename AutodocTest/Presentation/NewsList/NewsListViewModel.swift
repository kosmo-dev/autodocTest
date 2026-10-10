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

    private(set) var loaderState: LoaderState = .loading

    private var newsManager: NewsManagerProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(newsManager: NewsManagerProtocol) {
        self.newsManager = newsManager
    }

    func fetchNextPage() {
        Task {
            do {
                try await newsManager.fetchNewsPage()
                self.loaderState = newsManager.hasMoreNews ? .loading : .empty
                self.news = newsManager.getAllNews()
            } catch {
                loaderState = .error
            }
        }
    }

    func showDetailNews(_ id: Int) {
        guard let news = news.first(where: { $0.id == id }) else { return }
        delegate?.didSelectNews(news.fullUrl)
    }
}

// MARK: - Private
private extension NewsListViewModel {
}
