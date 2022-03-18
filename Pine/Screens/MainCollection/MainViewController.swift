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
    func fetchSearchData(query: String)
    func nextDetailImageScreen(imageData: ImageData)
    func mainSearchBarTappedEventTriggered()
    func mainCancelButtonTappedEventTriggered()
}

class MainViewController: UIViewController {
    lazy var mainViewManager: CollectionViewManager = .init(collectionView: imagesCollectionView)

    var viewModel: MainViewModel
    var output: MainViewOutput

    private let searchBar = UISearchBar()
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        return indicator
    }()
    private var titleLabelFoundNothing: UILabel = {
        let label = UILabel()
        label.text = Strings.mainTitleLabelFoundNothing
        label.font = UIFont.proTextFontMedium(ofSize: 24 * Layout.scaleFactorW)
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    private var labelFoundNothing: UILabel = {
        let label = UILabel()
        label.text = Strings.mainLabelFoundNothing
        label.font = UIFont.proTextFontMedium(ofSize: 14 * Layout.scaleFactorW)
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()

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
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingIndicator.center = view.center
        //        imagesCollectionView.frame = view.bounds
        titleLabelFoundNothing.frame = .init(x: 102.5, y: 282, width: 170, height: 29)
        labelFoundNothing.frame = .init(x: 0, y: 318, width: view.bounds.width, height: 16)

    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(imagesCollectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(titleLabelFoundNothing)
        view.addSubview(labelFoundNothing)
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

    private func startLoadingIndicator() {
        if viewModel.imagesData.count != 0 {
            loadingIndicator.stopAnimating()
            navigationController?.navigationBar.isHidden = false
        } else {
            loadingIndicator.startAnimating()
            switch viewModel.searchMode {
            case .random:
                navigationController?.navigationBar.isHidden = true
            case .query:
                navigationController?.navigationBar.isHidden = false
            }
        }
    }

    private func searchFoundNothing() {
        if viewModel.imagesData.isEmpty {
            titleLabelFoundNothing.isHidden = false
            labelFoundNothing.isHidden = false
            loadingIndicator.stopAnimating()
            searchBar.becomeFirstResponder()
        } else {
            titleLabelFoundNothing.isHidden = true
            labelFoundNothing.isHidden = true
        }
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
        if cellItems.count > 0 && viewModel.currentPage < viewModel.totalPage {
            cellItems.append(makeIndicatorCellItem())
        }
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
            startLoadingIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.output.fetchData()
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        output.fetchSearchData(query: query)
        imagesCollectionView.contentOffset = .zero
        
    }

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
        startLoadingIndicator()
        switch viewModel.searchMode {
        case .random:
            break
        case .query:
            searchBar.endEditing(true)
            searchFoundNothing()
        }
    }
}

// MARK: - SetConstraints

extension MainViewController {

    private func setConstraints() {
        imagesCollectionView.frame = view.bounds
        imagesCollectionView.frame = CGRect(x: 0, y: 94, width: view.bounds.width, height: view.bounds.height - 94)
    }
}
