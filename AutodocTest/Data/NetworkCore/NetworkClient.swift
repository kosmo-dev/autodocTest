//
//  NetworkClient.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

import Foundation

final class NetworkClient {
    let urlSession: URLSession
    let serverParams: ServerParams
    let jsonDecoder: JSONDecoder

    init(serverParams: ServerParams, urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
        self.serverParams = serverParams
        self.jsonDecoder = JSONDecoder()
    }
}

// MARK: - NetworkRouting
extension NetworkClient: NetworkRouting {
    func sendRequest<T: Decodable & Sendable>(_ endpoint: any Endpoint, type: T.Type) async throws -> T {
        let request = try RequestFactory.makeRequest(for: endpoint, serverParams: serverParams)

        let (data, response) = try await urlSession.data(for: request)

        let dto = try handleResponse(data: data, response: response, type: type)
        return dto
    }
}

// MARK: - Private
private extension NetworkClient {
    func handleResponse<T: Decodable>(data: Data, response: URLResponse, type: T.Type) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }

        switch httpResponse.statusCode {
        case 200..<300:
            let dto = try decode(data: data, type: type)
            return dto
        default:
            throw NetworkError.httpError(code: httpResponse.statusCode)
        }
    }

    func decode<T: Decodable>(data: Data, type: T.Type) throws -> T {
        let dto = try jsonDecoder.decode(type, from: data)
        return dto
    }
}

// MARK: - NetworkError
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(code: Int)
}
