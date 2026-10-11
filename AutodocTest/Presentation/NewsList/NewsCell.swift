//
//  NewsCell.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 10.10.2026.
//

import UIKit

final class NewsCell: UICollectionViewCell {
    private var title: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    private var newsDescription: UILabel = {
        let description = UILabel()
        description.font = UIFont.preferredFont(forTextStyle: .body)
        description.numberOfLines = 0
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()

    private var date: UILabel = {
        let date = UILabel()
        date.font = UIFont.preferredFont(forTextStyle: .caption1)
        date.textColor = UIColor.secondaryLabel
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()

    private var newsImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private var vStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.alignment = .fill
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()

    private var imageTask: Task<Void, Error>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        newsImage.image = nil
    }

    func configureView(with news: News, imagePixelSize: CGFloat) {
        title.text = news.title
        newsDescription.text = news.description
        loadImage(for: news, imagePixelSize: imagePixelSize)

        if let date = news.publishedDate {
            self.date.text = date.formatted(date: .abbreviated, time: .omitted)
        } else {
            self.date.text = ""
        }
    }

    private func setupUI() {
        [title, date, newsDescription, newsImage].forEach { vStack.addArrangedSubview($0) }
        contentView.addSubview(vStack)

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func loadImage(for news: News, imagePixelSize: CGFloat) {
        imageTask?.cancel()
        newsImage.isHidden = news.titleImageUrl == nil
        imageTask = Task {
            do {
                if let imageUrl = news.titleImageUrl {
                    let image = try await ImageLoader.shared.loadImage(imageUrl, maxPixelSize: imagePixelSize)
                    guard !Task.isCancelled else { return }
                    newsImage.image = image
                }
            } catch {
                guard !Task.isCancelled else { return }
                newsImage.isHidden = true
            }
        }
    }
}
