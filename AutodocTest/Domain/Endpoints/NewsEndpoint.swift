//
//  NewsEndpoint.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

struct GetNewsListEndpoint: Endpoint {
    let path: String
    let method: HTTPMethod = .get

    init(page: Int, maxItems: Int) {
        self.path = "/news" + "/\(page)" + "/\(maxItems)"
    }
}
