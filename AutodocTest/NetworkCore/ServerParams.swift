//
//  ServerParams.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 09.10.2026.
//

struct ServerParams {
    let server: String
    let apiVersion: String

    var fullUrl: String {
        server + apiVersion
    }
}
