//
//  LoaderCell.swift
//  AutodocTest
//
//  Created by Вадим Кузьмин on 10.10.2026.
//

import UIKit

protocol LoaderCellDelegate: AnyObject {
    func refetchButtonTapped()
}

final class LoaderCell: UICollectionViewCell {
    weak var delegate: LoaderCellDelegate?

    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .medium
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()

    private lazy var button: UIButton = {
        let button = UIButton(configuration: .tinted())
        button.isHidden = true
        button.configuration?.title = "Обновить"
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.refetchButtonTapped()
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with state: LoaderState) {
        switch state {
        case .loading:
            button.isHidden = true
            loader.startAnimating()
        case .error:
            loader.stopAnimating()
            button.isHidden = false
        case .empty:
            loader.stopAnimating()
            button.isHidden = true
        }
    }

    private func setupUI() {
        [loader, button].forEach { vStack.addArrangedSubview($0) }
        contentView.addSubview(vStack)

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
