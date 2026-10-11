//
//  News.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

import Foundation

struct News {
    let id: Int
    let title: String
    let description: String
    let publishedDate: Date?
    let fullUrl: String
    let titleImageUrl: String?
    let category: String?

    typealias ID = Int

    init(
        id: Int,
        title: String,
        description: String,
        publishedDate: Date,
        fullUrl: String,
        titleImageUrl: String,
        category: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.publishedDate = publishedDate
        self.fullUrl = fullUrl
        self.titleImageUrl = titleImageUrl
        self.category = category
    }

    init(dto: NewsDTO) {
        self.id = dto.id
        self.title = dto.title
        self.description = dto.description ?? ""

        if let publishedDate = dto.publishedDate {
            self.publishedDate = try? Date(publishedDate, strategy: Date.ISO8601FormatStyle.serverStyle)
        } else {
            self.publishedDate = nil
        }

        self.fullUrl = dto.fullUrl
        self.titleImageUrl = dto.titleImageUrl
        self.category = dto.categoryType
    }
}
