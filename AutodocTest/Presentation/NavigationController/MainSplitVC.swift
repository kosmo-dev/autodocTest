//
//  MainSplitVC.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 10.10.2026.
//

import UIKit


final class MainSplitVC: UISplitViewController {

    init() {
        super.init(style: .doubleColumn)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        #warning("Implement DI")
        let serverParams = ServerParams(server: "https://webapi.autodoc.ru", apiVersion: "/api")
        let networkClient = NetworkClient(serverParams: serverParams)
        let newsManager = NewsManager(networkClient: networkClient)

        let newsListViewModel = NewsListViewModel(newsManager: newsManager)

        let newsList = NewsListVC(viewModel: newsListViewModel)
        let newsDetail = NewsDetailVC()

        setViewController(newsList, for: .primary)
        setViewController(newsDetail, for: .secondary)
    }
}

extension MainSplitVC: UISplitViewControllerDelegate {
    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}
