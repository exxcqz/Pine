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
    func viewDidLoad()
    func clearRecentSearches()
    func searchCancelButtonEventTriggered()
}

class SearchViewController: UIViewController {
    var viewModel: SearchViewModel
    var output: SearchViewOutput

    private let searchBar = UISearchBar()
    private let recentLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.searchViewRecentTitle
        label.font = UIFont.proTextFontMedium(ofSize: 24 * Layout.scaleFactorW)
        return label
    }()

    private let clearButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.proTextFontRegular(ofSize: 14 * Layout.scaleFactorW)
        button.setTitle(Strings.searchViewClearButton, for: .normal)
        return button
    }()

    private let recentTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private var recentSearches: [String] = [
        "heelo",
        "privet",
        "poka"
    ]

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

    override func viewDidLayoutSubviews() {
        recentLabel.frame = CGRect(x: 15 * Layout.scaleFactorW, y: 109 * Layout.scaleFactorW, width: 200 * Layout.scaleFactorW, height: 29 * Layout.scaleFactorW)
        clearButton.frame = CGRect(x: 304 * Layout.scaleFactorW, y: 113 * Layout.scaleFactorW, width: 71 * Layout.scaleFactorW, height: 20 * Layout.scaleFactorW)
        recentTableView.frame = CGRect(x: 0, y: 138 * Layout.scaleFactorW, width: view.bounds.width, height: 634 * Layout.scaleFactorW)
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
    }

    private func setNavigationBar() {
        navigationItem.titleView = searchBar
        navigationItem.hidesBackButton = true
    }

    private func setupSearchBar() {
        searchBar.delegate = self
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
        recentTableView.reloadData()
    }
}

//MARK: - SearchViewInput

extension SearchViewController: SearchViewInput {

    func update(with viewModel: SearchViewModel, force: Bool, animated: Bool) {
        self.viewModel = viewModel
    }
}

//MARK: - UITableViewDataSource

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

//MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0 * Layout.scaleFactorW
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output.searchCancelButtonEventTriggered()
    }
}
