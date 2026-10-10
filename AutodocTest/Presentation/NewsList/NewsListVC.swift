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

    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())

    private var dataSource: UICollectionViewDiffableDataSource<NewsListVC.Section, Item>?

    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self

        configureDataSource()
        setupBindings()
    }
}

// MARK: - Configuration
private extension NewsListVC {
    func configureDataSource() {
        let newsCell = UICollectionView.CellRegistration<NewsCell, News.ID> { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            let news = self.viewModel.news[indexPath.item]
            cell.configureView(with: news)
        }

        let loaderCell = UICollectionView.CellRegistration<LoaderCell, Loader> { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            let state = viewModel.loaderState
            cell.delegate = self
            cell.configure(with: state)
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .news(let id):
                return collectionView.dequeueConfiguredReusableCell(using: newsCell, for: indexPath, item: id)
            case .loader(let state):
                return collectionView.dequeueConfiguredReusableCell(using: loaderCell, for: indexPath, item: state)
            }
        })
    }

    func setupBindings() {
        viewModel.$news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapshot()
            }
            .store(in: &cancellables)
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        snapshot.appendSections([.news])
        snapshot.appendItems(viewModel.news.map({ .news($0.id) }), toSection: .news)

        if viewModel.loaderState != .empty {
            snapshot.appendSections([.loader])
            snapshot.appendItems([.loader(Loader(state: viewModel.loaderState))], toSection: .loader)
        }

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension NewsListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSource?.itemIdentifier(for: indexPath) == .loader(.loading) {
            viewModel.fetchNextPage()
        }
    }
}

// MARK: - LoaderCellDelegate
extension NewsListVC: LoaderCellDelegate {
    func refetchButtonTapped() {
        viewModel.fetchNextPage()
    }
}

// MARK: - Layout items
private extension NewsListVC {
    nonisolated enum Section: Hashable {
        case news
        case loader
    }

    nonisolated enum Item: Hashable {
        case news(News.ID)
        case loader(Loader)
    }

    nonisolated enum Loader: Hashable {
        case loading
        case error
        case empty

        init(state: LoaderState) {
            switch state {
            case .loading:
                self = .loading
            case .empty:
                self = .empty
            case .error:
                self = .error
            }
        }
    }
}

// MARK: - Layout Factory
private extension NewsListVC {
    func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            switch self?.dataSource?.sectionIdentifier(for: sectionIndex) {
            case .news:
                return self?.makeNewsSection()
            case .loader:
                return self?.makeLoaderSection()
            default:
                assertionFailure("Section layout not implemented")
                return self?.makeLoaderSection()
            }
        }
    }

    func makeNewsSection() -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 250
        let columns = 1

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: columns
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    func makeLoaderSection() -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 60

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return section
    }
}
