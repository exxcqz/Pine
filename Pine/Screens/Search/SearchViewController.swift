//
//  SearchViewController.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.03.2022.
//

import UIKit

class SearchViewController: UIViewController {

    private let searchBar = UISearchBar()
    private let recentLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.searchViewRecentTitle
        label.font = UIFont.proTextFontMedium(ofSize: 24 * Layout.scaleFactorW)
        return label
    }()

    private let clearButton: UIButton = {
        let button = UIButton()
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

    private let recentSearches: [String] = [
        "heelo",
        "privet",
        "poka"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupViews()
        setDelegate()
    }

    override func viewDidLayoutSubviews() {
        recentLabel.frame = CGRect(x: 15, y: 109, width: 200, height: 29)
        clearButton.frame = CGRect(x: 304, y: 113, width: 71, height: 20)
        recentTableView.frame = CGRect(x: 0, y: 138, width: view.bounds.width, height: 634)
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(recentLabel)
        view.addSubview(clearButton)
        view.addSubview(recentTableView)
    }

    private func setDelegate() {
        recentTableView.dataSource = self
        recentTableView.delegate = self
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
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
}

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = recentSearches[indexPath.row]
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
    }
}
