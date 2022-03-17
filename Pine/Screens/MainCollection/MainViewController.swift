//
//  MainViewController.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import UIKit
import CollectionViewTools

protocol MainViewInput: class {
    func update(with viewModel: MainViewModel, force: Bool, animated: Bool)
}

protocol MainViewOutput: class {
    func fetchData()
    func nextDetailImageScreen(imageData: ImageData)
    func mainSearchBarTappedEventTriggered()
    func mainCancelButtonTappedEventTriggered()
}

class MainViewController: UIViewController {
    lazy var mainViewManager: CollectionViewManager = .init(collectionView: imagesCollectionView)

    var viewModel: MainViewModel
    var output: MainViewOutput
    
    private let searchBar = UISearchBar()
    private var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(MainIndicatorViewCell.self, forCellWithReuseIdentifier: "indicator")
        collectionView.keyboardDismissMode = .onDrag
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(viewModel: MainViewModel, output: MainViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setDelegate()
        setConstraints()
        setNavigationBar()
        setupSearchBar()

        resetMainCollection(imagesData: viewModel.imagesData)
        mainViewManager.sectionItems = [makeMainSectionItem(imagesData: viewModel.imagesData)]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        switch viewModel.searchMode {
        case .random:
            searchBar.resignFirstResponder()
        case .query:
            searchBar.becomeFirstResponder()
            searchBar.endEditing(true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        imagesCollectionView.frame = view.bounds

    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(imagesCollectionView)
    }

    private func setDelegate() {
        mainViewManager.scrollDelegate = self
        searchBar.delegate = self
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.barStyle = .default
        navigationItem.titleView = searchBar
    }

    private func setupSearchBar() {
        switch viewModel.searchMode {
        case .random:
            searchBar.placeholder = Strings.searchPlaceholder
        case .query:
            navigationItem.hidesBackButton = true
            searchBar.showsCancelButton = true
            searchBar.text = viewModel.query
        }
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .black
        let cancelImage = UIImage(named: Icons.icCross)
        let loupeImage = UIImage(named: Icons.icLoupe)
        searchBar.setImage(cancelImage, for: .clear, state: .normal)
        searchBar.setImage(loupeImage, for: .search, state: .normal)
    }

    private func resetMainCollection(imagesData: [ImageData]) {
        mainViewManager.update([makeMainSectionItem(imagesData: imagesData)], shouldReloadData: true) {
            print("Reload complete")
        }
    }

    // MARK: - Factory methods

    private func makeMainSectionItem(imagesData: [ImageData]) -> CollectionViewSectionItem {
        let sectionItem = MainSectionItem()
        var cellItems: [CollectionViewCellItem] = imagesData.map { imageData in
            makeCellItem(imageData: imageData)
        }
        cellItems.append(makeIndicatorCellItem())
        sectionItem.cellItems = cellItems
        sectionItem.minimumLineSpacing = 4 * Layout.scaleFactorW
        return sectionItem
    }

    private func makeCellItem(imageData: ImageData) -> MainViewCellItem {
        let cellItem = MainViewCellItem(imageData: imageData)
        cellItem.itemDidSelectHandler = { _ in
            self.output.nextDetailImageScreen(imageData: imageData)
        }
        return cellItem
    }

    private func makeIndicatorCellItem() -> MainIndicatorViewCellItem {
        let cellItem = MainIndicatorViewCellItem()
        return cellItem
    }
}

// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offset > (contentHeight - scrollView.frame.height) && viewModel.currentPage < viewModel.totalPage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.output.fetchData()
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        switch viewModel.searchMode {
        case .random:
            output.mainSearchBarTappedEventTriggered()
        case .query:
            break
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output.mainCancelButtonTappedEventTriggered()
    }
}

// MARK: - MainViewInput

extension MainViewController: MainViewInput {

    func update(with viewModel: MainViewModel, force: Bool, animated: Bool) {
        self.viewModel = viewModel
        resetMainCollection(imagesData: viewModel.imagesData)
    }
}

// MARK: - SetConstraints

extension MainViewController {

    private func setConstraints() {
        imagesCollectionView.frame = view.bounds
        imagesCollectionView.frame = CGRect(x: 0, y: 94, width: view.bounds.width, height: view.bounds.height - 94)
    }
}
