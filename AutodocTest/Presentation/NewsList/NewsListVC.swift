//
//  NewsListVC.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 10.10.2026.
//

import UIKit
import Combine

final class NewsListVC: UIViewController {
    private let viewModel: NewsListViewModel

    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupBindings()
        viewModel.fetchNextPage()
    }
}

extension NewsListVC {
    func setupBindings() {
        viewModel.$news.sink { news in

        }
        .store(in: &cancellables)
    }
}
