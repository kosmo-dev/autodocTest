//
//  NewsDTO.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

struct NewsDTO: Codable {
    let id: Int
    let title: String
    let description: String?
    let publishedDate: String?
    let url: String?
    let fullUrl: String
    let titleImageUrl: String?
    let categoryType: String?
}
