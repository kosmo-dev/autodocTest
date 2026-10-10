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
        title.font = UIFont.preferredFont(forTextStyle: .body)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
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
    }

    private func setupUI() {
        contentView.addSubview(title)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
