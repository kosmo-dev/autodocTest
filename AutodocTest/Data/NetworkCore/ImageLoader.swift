//
//  ImageLoader.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 10.10.2026.
//

import UIKit

actor ImageLoader {
    static let shared = ImageLoader()

    private var cache = NSCache<NSString, UIImage>()

    private var inProgress: [String: Task<UIImage, Error>] = [:]

    private init() {}

    func loadImage(_ urlString: String) async throws -> UIImage {
        if let cached = cache.object(forKey: NSString(string: urlString)) {
            return cached
        }

        if let inProgress = inProgress[urlString] {
            return try await inProgress.value
        }

        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }

        let task = Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { throw ImageLoaderError.imageUnavailable }
            return image
        }
        inProgress[urlString] = task

        let image = try await task.value
        inProgress[urlString] = nil
        cache.setObject(image, forKey: NSString(string: urlString))

        return image
    }
}

enum ImageLoaderError: Error {
    case imageUnavailable
}
