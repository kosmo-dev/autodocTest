//
//  NewsManagerProtocol.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//


protocol NewsManagerProtocol {
    var hasMoreNews: Bool { get }

    func fetchNewsPage() async throws
    func getAllNews() -> [News]
}
