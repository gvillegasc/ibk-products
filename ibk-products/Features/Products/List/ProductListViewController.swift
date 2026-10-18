//
//  ProductListViewController.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Combine
import UIKit

final class ProductListViewController: UIViewController {
    nonisolated private enum Section {
        case main
    }

    // MARK: - Properties

    private let viewModel: ProductListViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        tableView.delegate = self
        return tableView
    }()

    private lazy var dataSource = UITableViewDiffableDataSource<Section, Product>(
        tableView: tableView
    ) { tableView, indexPath, product in
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        var content = UIListContentConfiguration.cell()
        content.text = product.title
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    private let nextPageIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 0, height: 56)
        return indicator
    }()

    private static let cellIdentifier = "ProductCell"

    // MARK: - Initialization

    init(viewModel: ProductListViewModel) {
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

        title = String(localized: "Productos")
        view.backgroundColor = .systemBackground
        setUpTableView()
        bindViewModel()
        viewModel.loadFirstPageIfNeeded()
    }

    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        switch viewModel.state {
        case .loading:
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.loading()
        case .loaded:
            contentUnavailableConfiguration = nil
        case .empty:
            var configuration = UIContentUnavailableConfiguration.empty()
            configuration.image = UIImage(systemName: "bag")
            configuration.text = String(localized: "No hay productos")
            contentUnavailableConfiguration = configuration
        case .error:
            contentUnavailableConfiguration = makeErrorConfiguration()
        }
    }

    // MARK: - Setup

    private func setUpTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func bindViewModel() {
        viewModel.$state
            .sink { [weak self] state in
                self?.tableView.isHidden = state != .loaded
                self?.setNeedsUpdateContentUnavailableConfiguration()
            }
            .store(in: &cancellables)

        viewModel.$products
            .sink { [weak self] products in
                self?.apply(products)
            }
            .store(in: &cancellables)

        viewModel.$isLoadingNextPage
            .sink { [weak self] isLoading in
                self?.updateNextPageIndicator(isLoading: isLoading)
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func apply(_ products: [Product]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func updateNextPageIndicator(isLoading: Bool) {
        if isLoading {
            nextPageIndicator.startAnimating()
            tableView.tableFooterView = nextPageIndicator
        } else {
            nextPageIndicator.stopAnimating()
            tableView.tableFooterView = nil
        }
    }

    private func makeErrorConfiguration() -> UIContentUnavailableConfiguration {
        var configuration = UIContentUnavailableConfiguration.empty()
        configuration.image = UIImage(systemName: "exclamationmark.triangle")
        configuration.text = String(localized: "No se pudieron cargar los productos")
        configuration.secondaryText = String(localized: "Revisa tu conexión e inténtalo de nuevo.")

        var button = UIButton.Configuration.filled()
        button.title = String(localized: "Reintentar")
        configuration.button = button
        configuration.buttonProperties.primaryAction = UIAction { [weak self] _ in
            self?.viewModel.loadFirstPage()
        }
        return configuration
    }
}

// MARK: - UITableViewDelegate

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadNextPageIfNeeded(currentIndex: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectProduct(at: indexPath.row)
    }
}

// MARK: - Preview

#Preview {
    ProductListViewController(
        viewModel: .make(products: .getMockData())
    )
}
