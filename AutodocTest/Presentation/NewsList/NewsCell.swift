//
//  NewsCell.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 10.10.2026.
//

import UIKit

final class NewsCell: UICollectionViewCell {
    var title: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    var newsDescription: UILabel = {
        let description = UILabel()
        description.font = UIFont.preferredFont(forTextStyle: .body)
        description.numberOfLines = 0
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()

    var date: UILabel = {
        let date = UILabel()
        date.font = UIFont.preferredFont(forTextStyle: .caption1)
        date.textColor = UIColor.secondaryLabel
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()

    var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    var vStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.alignment = .fill
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView(with news: News) {
        title.text = news.title
        newsDescription.text = news.description
        image.image = UIImage(systemName: "photo")

        if let date = news.publishedDate {
            self.date.text = date.formatted(date: .abbreviated, time: .omitted)
        } else {
            self.date.text = ""
        }
    }

    private func setupUI() {
        [title, date, newsDescription, image].forEach { vStack.addArrangedSubview($0) }
        contentView.addSubview(vStack)

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
