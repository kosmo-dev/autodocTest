//
//  NewsListDTO.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

struct NewsListDTO: Decodable {
    let news: [NewsDTO]
    let totalCount: Int?
}
