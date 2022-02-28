//
//  ViewController.swift
//  Pine
//
//  Created by Nikita Gavrikov on 24.02.2022.
//

import UIKit

class MainCollectionViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.keyboardDismissMode = .onDrag
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var imagesData = [ImageInfo]()
    private var randomData = [RandomImage]()
    private var query = ""
    private var currentPage = 1
    private var totalPage = 1
    private let scaleWidth = UIScreen.main.bounds.size.width / 375

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setDelegate()
        setConstraints()
        setNavigationBar()
        setupSearchController()
        CacheManager.cache.removeAllObjects()
        fetchRandomData(page: 1)
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(imagesCollectionView)
    }

    private func setDelegate() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        searchController.searchBar.delegate = self
    }

    private func setNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        let cancelImage = UIImage(named: "icCross")
        let loupeImage = UIImage(named: "icLoupe")
        searchController.searchBar.setImage(cancelImage, for: .clear, state: .normal)
        searchController.searchBar.setImage(loupeImage, for: .search, state: .normal)
        searchController.searchBar.tintColor = .black
    }

    private func fetchData(query: String, page: Int) {
        NetworkDataFetch.shared.fetchSearchData(query: query, page: page) { searchResult, error in
            if error == nil {
                guard let searchResult = searchResult else { return }
                self.imagesData.append(contentsOf: searchResult.results)
                self.totalPage = searchResult.totalPages
                if self.currentPage > self.totalPage { return }
                self.currentPage += 1
                DispatchQueue.main.async {
                    self.imagesCollectionView.reloadData()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    private func fetchRandomData(page: Int) {
        NetworkDataFetch.shared.fetchRandomData(page: page) { result, error in
            guard let result = result else { return }
            self.randomData.append(contentsOf: result)
            self.currentPage += 1
            print(self.randomData.count)
            DispatchQueue.main.async {
                self.imagesCollectionView.reloadData()
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
        let imageInfo = randomData[indexPath.row]
        cell.configureImagesCell(imageInfo: imageInfo)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: view.bounds.width,
            height: 270
        )
    }
}

// MARK: - UISearchBarDelegate
extension MainCollectionViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
}

// MARK: - SetConstraints
extension MainCollectionViewController {

    private func setConstraints() {
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imagesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            imagesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            imagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

