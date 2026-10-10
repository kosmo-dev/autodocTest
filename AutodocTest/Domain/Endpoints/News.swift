//
//  News.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

struct GetNewsListEndpoint: Endpoint {
    let path: String
    let method: HTTPMethod = .get

    init(from: Int, to: Int) {
        self.path = "/news" + "/\(from)" + "/\(to)"
    }
}
