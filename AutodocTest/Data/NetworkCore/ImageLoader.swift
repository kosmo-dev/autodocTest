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

    private init() {
        cache.countLimit = 300
    }

    func loadImage(_ urlString: String, maxPixelSize: CGFloat) async throws -> UIImage {
        if let cached = cache.object(forKey: NSString(string: urlString)) {
            return cached
        }

        if let inProgress = inProgress[urlString] {
            return try await inProgress.value
        }

        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }

        let task = Task.detached(priority: .userInitiated) { [weak self] in
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = self?.downsample(data: data, maxPixelSize: maxPixelSize) else { throw ImageLoaderError.imageUnavailable }
            return image
        }
        inProgress[urlString] = task
        defer { inProgress[urlString] = nil }

        let image = try await task.value
        cache.setObject(image, forKey: NSString(string: urlString))

        return image
    }
}

private extension ImageLoader {
    nonisolated private func downsample(data: Data, maxPixelSize: CGFloat) -> UIImage? {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions) else { return nil }

        let options = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
        ] as CFDictionary

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

enum ImageLoaderError: Error {
    case imageUnavailable
}
