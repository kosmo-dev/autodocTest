//
//  RequestFactory.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

import Foundation

struct RequestFactory {
    static func makeRequest(for endpoint: Endpoint, serverParams: ServerParams) throws -> URLRequest {
        var urlComponents = URLComponents()

        if endpoint.method == .get {
            urlComponents.queryItems = endpoint.queryItems
        }

        urlComponents.path = serverParams.fullUrl + endpoint.path

        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }

        return request
    }
}
