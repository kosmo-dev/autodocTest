//
//  NewsDetailVC.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 10.10.2026.
//

import UIKit
import WebKit
import Combine

final class NewsDetailVC: UIViewController {
    private var viewModel: NewsDetailViewModel
    private var cancellables: Set<AnyCancellable> = []

    private var placeholder: UILabel = {
        let text = UILabel()
        text.text = "Choose news"
        text.font = UIFont.preferredFont(forTextStyle: .title1)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.hidesWhenStopped = true
        loader.style = .large
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(viewModel: NewsDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel.onDisappear()
    }
}

extension NewsDetailVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.pageDidLoad()
    }
}

// MARK: - Private
private extension NewsDetailVC {
    func setupUI() {
        [webView, loader, placeholder].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            placeholder.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            loader.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    func setupBinding() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.load()
        }.store(in: &cancellables)
    }

    func load() {
        guard let request = viewModel.urlRequest else { return }

        switch viewModel.state {
        case .loaded:
            loader.stopAnimating()
        case .loading:
            placeholder.isHidden = true
            loader.startAnimating()
            webView.isHidden = false
            webView.load(request)
        case .placeholder:
            webView.isHidden = true
            loader.stopAnimating()
            placeholder.isHidden = false
        }
    }
}
