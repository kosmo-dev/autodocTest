//
//  NewsDetailViewModel.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 10.10.2026.
//

import Foundation
import Combine

@MainActor
final class NewsDetailViewModel {
    @Published private(set) var state: State = .placeholder
    private(set) var urlRequest: URLRequest?

    init() {}

    func load(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            urlRequest = request
            state = .loading
        } else {
            state = .placeholder
        }
    }

    func onDisappear() {
        state = .placeholder
    }

    func pageDidLoad() {
        state = .loaded
    }
}

extension NewsDetailViewModel {
    enum State {
        case placeholder
        case loading
        case loaded
    }
}
