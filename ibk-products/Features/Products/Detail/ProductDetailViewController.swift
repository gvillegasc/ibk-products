//
//  ProductDetailViewController.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 18/10/26.
//

import SDWebImage
import UIKit

final class ProductDetailViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: ProductDetailViewModel

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        imageView.tintColor = .tertiaryLabel
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.isAccessibilityElement = true
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
        return imageView
    }()

    private let titleLabel = ProductDetailViewController.makeLabel(textStyle: .title2, textColor: .label)
    private let priceLabel = ProductDetailViewController.makeLabel(textStyle: .title3, textColor: .tintColor)
    private let categoryLabel = ProductDetailViewController.makeLabel(
        textStyle: .subheadline,
        textColor: .secondaryLabel
    )
    private let descriptionLabel = ProductDetailViewController.makeLabel(textStyle: .body, textColor: .label)

    private static let maxImageHeight: CGFloat = 360

    // MARK: - Initialization

    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        setUpLayout()
        configureContent()
    }

    // MARK: - Setup

    private func setUpLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        [imageView, titleLabel, priceLabel, categoryLabel, descriptionLabel]
            .forEach(contentStackView.addArrangedSubview)
        contentStackView.setCustomSpacing(16, after: imageView)
        contentStackView.setCustomSpacing(16, after: categoryLabel)

        let squareImage = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        squareImage.priority = .defaultHigh

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor,
                constant: -24
            ),
            contentStackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            squareImage,
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: Self.maxImageHeight),
        ])
    }

    private func configureContent() {
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.formattedPrice
        categoryLabel.text = viewModel.categoryName
        descriptionLabel.text = viewModel.description

        imageView.accessibilityLabel = viewModel.title
        imageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "photo"))
    }

    // MARK: - Private Methods

    private static func makeLabel(textStyle: UIFont.TextStyle, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = textColor
        label.numberOfLines = 0
        return label
    }
}

// MARK: - Preview

#Preview {
    ProductDetailViewController(
        viewModel: .make(product: .getMockData())
    )
}
