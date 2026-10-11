//
//  Endpoint.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

import Foundation

nonisolated protocol Endpoint: Sendable {
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: Sendable]? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var header: [String: String]? {
        nil
    }

    var body: [String: Sendable]? {
        nil
    }

    var queryItems: [URLQueryItem]? {
        nil
    }
}

enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

extension Endpoint {
    static var applicationJSON: [String: String] {
        ["Content-Type": "application/json"]
    }
}
