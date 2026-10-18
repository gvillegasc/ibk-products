//
//  MenuViewController.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 18/10/26.
//

import Combine
import UIKit

final class MenuViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: MenuViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private static let cellIdentifier = "ColorCell"

    // MARK: - Initialization

    init(viewModel: MenuViewModel) {
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

        title = String(localized: "Menú")
        view.backgroundColor = .systemGroupedBackground
        setUpTableView()
        bindViewModel()
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
        viewModel.$selectedColor
            .dropFirst()
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.colors.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(localized: "Color del tab bar")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        let tabBarColor = viewModel.colors[indexPath.row]
        let isSelected = tabBarColor == viewModel.selectedColor

        var content = UIListContentConfiguration.cell()
        content.text = tabBarColor.title
        content.image = UIImage(systemName: tabBarColor.color == nil ? "circle.lefthalf.filled" : "circle.fill")
        content.imageProperties.tintColor = tabBarColor.color ?? .secondaryLabel
        cell.contentConfiguration = content
        cell.accessoryType = isSelected ? .checkmark : .none
        cell.accessibilityTraits = isSelected ? [.button, .selected] : .button
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectColor(at: indexPath.row)
    }
}

// MARK: - Preview

#Preview {
    MenuViewController(
        viewModel: .make()
    )
}
