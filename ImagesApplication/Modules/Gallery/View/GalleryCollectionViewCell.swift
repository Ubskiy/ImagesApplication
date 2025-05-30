//
//  GalleryCollectionViewCell.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 29.05.2025.
//
import UIKit

protocol GalleryCollectionViewCellDelegate: AnyObject {
    func didTapRetry(in cell: GalleryCollectionViewCell)
}

final class GalleryCollectionViewCell: UICollectionViewCell {
    static let identifier = "GalleryCollectionViewCell"
    weak var delegate: GalleryCollectionViewCellDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 4
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        
        let buttonSize = CGSize(width: 80, height: 30)
        retryButton.frame = CGRect(
            x: (contentView.bounds.width - buttonSize.width) / 2,
            y: (contentView.bounds.height - buttonSize.height) / 2,
            width: buttonSize.width,
            height: buttonSize.height
        )
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(retryButton)
        retryButton.center = imageView.center
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        imageView.frame = contentView.bounds
        layer.cornerRadius = 8
        clipsToBounds = true
        retryButton.isHidden = true
    }
    
    @objc private func retryButtonTapped() {
        delegate?.didTapRetry(in: self)
    }
    
    func configure(with image: UIImage?, isLoading: Bool, isError: Bool) {
        if isLoading {
            imageView.image = UIImage(systemName: "exclamationmark.triangle")
            return
        }
        if isError {
            imageView.image = UIImage(systemName: "exclamationmark.triangle")
            backgroundColor = .systemGray6
            retryButton.isHidden = false
        } else if let image = image {
            imageView.image = image
            backgroundColor = .clear
            retryButton.isHidden = true
        } else {
            imageView.image = UIImage(systemName: "photo")?
                .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            backgroundColor = .systemGray5
            retryButton.isHidden = true
        }
    }
}
