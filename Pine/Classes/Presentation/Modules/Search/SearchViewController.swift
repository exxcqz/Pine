//
//  SearchViewController.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.03.2022.
//

import UIKit

protocol SearchViewInput: class {
    func update(with viewModel: SearchViewModel, force: Bool, animated: Bool)
}

protocol SearchViewOutput: class {
    func updateRecentSearches()
    func clearRecentSearches()
    func searchCancelButtonEventTriggered()
    func searchButtonEventTriggered(query: String)
}

final class SearchViewController: UIViewController {
    private var viewModel: SearchViewModel
    private let output: SearchViewOutput

    private lazy var searchBar = UISearchBar()
    private lazy var recentLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.searchViewRecentTitle
        label.font = UIFont.proTextFontMedium(ofSize: 24 * Layout.scaleFactorW)
        return label
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.proTextFontRegular(ofSize: 14 * Layout.scaleFactorW)
        button.setTitle(Strings.searchViewClearButton, for: .normal)
        return button
    }()

    private lazy var recentTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    init(viewModel: SearchViewModel, output: SearchViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupViews()
        setDelegate()
        setNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.updateRecentSearches()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recentLabel.frame = .init(
            x: 15 * Layout.scaleFactorW,
            y: (15 * Layout.scaleFactorW) + view.safeAreaInsets.top,
            width: 200 * Layout.scaleFactorW,
            height: 29 * Layout.scaleFactorW
        )
        clearButton.frame = .init(
            x: 304 * Layout.scaleFactorW,
            y: (21 * Layout.scaleFactorW) + view.safeAreaInsets.top,
            width: 71 * Layout.scaleFactorW,
            height: 20 * Layout.scaleFactorW
        )
        recentTableView.frame = .init(
            x: 0,
            y: (44 * Layout.scaleFactorW) + view.safeAreaInsets.top,
            width: view.bounds.width,
            height: 634 * Layout.scaleFactorW
        )
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(recentLabel)
        view.addSubview(clearButton)
        view.addSubview(recentTableView)
        clearButton.addTarget(self, action: #selector(clearRecentSearches), for: .touchUpInside)
    }

    private func setDelegate() {
        recentTableView.dataSource = self
        recentTableView.delegate = self
        searchBar.delegate = self
    }

    private func setNavigationBar() {
        navigationItem.titleView = searchBar
        navigationItem.hidesBackButton = true
    }

    private func setupSearchBar() {
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = Strings.searchPlaceholder
        searchBar.tintColor = .black
        searchBar.showsCancelButton = true
        let cancelImage = UIImage(named: Icons.icCross)
        let loupeImage = UIImage(named: Icons.icLoupe)
        searchBar.setImage(cancelImage, for: .clear, state: .normal)
        searchBar.setImage(loupeImage, for: .search, state: .normal)
        searchBar.becomeFirstResponder()
    }

    @objc private func clearRecentSearches() {
        output.clearRecentSearches()
    }

    private func fetchDataOnQuery(query: String) {
        output.searchButtonEventTriggered(query: query)
    }
}

// MARK: - SearchViewInput

extension SearchViewController: SearchViewInput {

    func update(with viewModel: SearchViewModel, force: Bool, animated: Bool) {
        self.viewModel = viewModel
        recentTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.recentSearches[indexPath.row]
        cell.textLabel?.tintColor = .black
        cell.textLabel?.font = UIFont.proTextFontMedium(ofSize: 14 * Layout.scaleFactorW)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0 * Layout.scaleFactorW
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.searchButtonEventTriggered(query: viewModel.recentSearches[indexPath.row])
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        fetchDataOnQuery(query: query)

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output.searchCancelButtonEventTriggered()
    }
}
