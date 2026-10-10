//
//  NewsListViewModel.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 10.10.2026.
//

import Foundation
import Combine

@MainActor
final class NewsListViewModel: ObservableObject {
    @Published private(set) var news: [News] = []

    private var newsManager: NewsManagerProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(newsManager: NewsManagerProtocol) {
        self.newsManager = newsManager
    }

    func fetchNextPage() {
        Task {
            try await newsManager.fetchNewsPage()
            self.news = newsManager.getNews()
        }
    }

    func showDetailNews(_ id: Int) {

    }
}
