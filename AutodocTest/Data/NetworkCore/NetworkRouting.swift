//
//  NetworkRouting.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

protocol NetworkRouting {
    func sendRequest<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T
}
