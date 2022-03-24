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

final class MainViewController: UIViewController {
    lazy var mainViewManager: CollectionViewManager = .init(collectionView: imagesCollectionView)

    private var viewModel: MainViewModel
    private let output: MainViewOutput

    private lazy var searchBar = UISearchBar()
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()

    private lazy var titleLabelFoundNothing: UILabel = {
        let label = UILabel()
        label.text = Strings.mainTitleLabelFoundNothing
        label.font = UIFont.proTextFontMedium(ofSize: 24 * Layout.scaleFactorW)
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()

    private lazy var labelFoundNothing: UILabel = {
        let label = UILabel()
        label.text = Strings.mainLabelFoundNothing
        label.font = UIFont.proTextFontMedium(ofSize: 14 * Layout.scaleFactorW)
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()

    private lazy var titleLabelNoConnection: UILabel = {
        let label = UILabel()
        label.text = Strings.mainTitleLabelNoConnection
        label.font = UIFont.proTextFontMedium(ofSize: 24 * Layout.scaleFactorW)
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()

    private lazy var labelNoConnection: UILabel = {
        let label = UILabel()
        label.text = Strings.mainLabelNoConnection
        label.font = UIFont.proTextFontMedium(ofSize: 14 * Layout.scaleFactorW)
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()

    private lazy var titleLabelSearchWrong: UILabel = {
        let label = UILabel()
        label.text = Strings.mainTitleLabelSearchWrong
        label.font = UIFont.proTextFontMedium(ofSize: 24 * Layout.scaleFactorW)
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()

    private lazy var labelSearchWrong: UILabel = {
        let label = UILabel()
        label.text = Strings.mainLabelSearchWrong
        label.font = UIFont.proTextFontMedium(ofSize: 14 * Layout.scaleFactorW)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()

    private lazy var buttonSearchWrong: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(Strings.mainButtonSearchWrong, for: .normal)
        button.titleLabel?.font = UIFont.latoFontBold(ofSize: 16 * Layout.scaleFactorW)
        button.layer.cornerRadius = 6 * Layout.scaleFactorW
        button.tintColor = .white
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(retryFetchSearchData), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(MainIndicatorViewCell.self, forCellWithReuseIdentifier: "indicator")
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
        setNavigationBar()
        setupSearchBar()
        resetMainCollection(imagesData: viewModel.imagesData)
        mainViewManager.sectionItems = [makeMainSectionItem(imagesData: viewModel.imagesData)]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        searchBar.resignFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imagesCollectionView.frame = .init(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.bounds.width,
            height: view.bounds.height - view.safeAreaInsets.top
        )
        loadingIndicator.frame = .init(
            x: 0,
            y: 0,
            width: 24 * Layout.scaleFactorW,
            height: 24 * Layout.scaleFactorW
        )
        loadingIndicator.center = view.center
        titleLabelFoundNothing.frame = .init(
            x: 102.5 * Layout.scaleFactorW,
            y: 282 * Layout.scaleFactorW,
            width: 170 * Layout.scaleFactorW,
            height: 29 * Layout.scaleFactorW
        )
        labelFoundNothing.frame = .init(
            x: 0,
            y: 318 * Layout.scaleFactorW,
            width: view.bounds.width,
            height: 16 * Layout.scaleFactorW
        )
        titleLabelNoConnection.frame = .init(
            x: 0,
            y: 320 * Layout.scaleFactorW,
            width: view.bounds.width,
            height: 29 * Layout.scaleFactorW
        )
        labelNoConnection.frame = .init(
            x: 0,
            y: 356 * Layout.scaleFactorW,
            width: view.bounds.width,
            height: 16 * Layout.scaleFactorW
        )
        titleLabelSearchWrong.frame = .init(
            x: 0,
            y: 245 * Layout.scaleFactorW,
            width: view.bounds.width,
            height: 29 * Layout.scaleFactorW
        )
        labelSearchWrong.frame = .init(
            x: 0,
            y: 281 * Layout.scaleFactorW,
            width: view.bounds.width,
            height: 34 * Layout.scaleFactorW
        )
        buttonSearchWrong.frame = .init(
            x: 0,
            y: 330 * Layout.scaleFactorW,
            width: 160 * Layout.scaleFactorW,
            height: 40 * Layout.scaleFactorW
        )
        buttonSearchWrong.center.x = view.center.x
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(imagesCollectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(titleLabelFoundNothing)
        view.addSubview(labelFoundNothing)
        view.addSubview(titleLabelNoConnection)
        view.addSubview(labelNoConnection)
        view.addSubview(titleLabelSearchWrong)
        view.addSubview(labelSearchWrong)
        view.addSubview(buttonSearchWrong)
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
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
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

    private func checkNetworkConnection() {
        if !viewModel.networkConnection {
            if viewModel.currentPage == 1 {
                imagesCollectionView.isHidden = true
                switch viewModel.searchMode {
                case .random:
                    titleLabelNoConnection.isHidden = false
                    labelNoConnection.isHidden = false
                    DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                        self.output.fetchData()
                    }
                case .query:
                    titleLabelSearchWrong.isHidden = false
                    labelSearchWrong.isHidden = false
                    buttonSearchWrong.isHidden = false
                }
                loadingIndicator.stopAnimating()
            }
        } else {
            imagesCollectionView.isHidden = false
            titleLabelNoConnection.isHidden = true
            labelNoConnection.isHidden = true
            titleLabelSearchWrong.isHidden = true
            labelSearchWrong.isHidden = true
            buttonSearchWrong.isHidden = true
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

    @objc private func retryFetchSearchData() {
        output.fetchData()
    }

    private func hideKeyboard() {
        searchBar.endEditing(true)
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
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
        let cellItem = MainViewCellItem(imageData: imageData, viewController: self)
        cellItem.itemDidSelectHandler = { _ in
            self.output.nextDetailImageScreen(imageData: imageData)
        }
        return cellItem
    }

    private func makeIndicatorCellItem() -> MainIndicatorViewCellItem {
        let cellItem = MainIndicatorViewCellItem(networkConnection: viewModel.networkConnection)
        if !viewModel.networkConnection {
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                self.output.fetchData()
            }
        }
        return cellItem
    }
}

// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideKeyboard()
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offset > (contentHeight - scrollView.frame.height - 20) && viewModel.currentPage < viewModel.totalPage {
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
            checkNetworkConnection()
        case .query:
            hideKeyboard()
            checkNetworkConnection()
            if viewModel.networkConnection {
                searchFoundNothing()
            }
        }
    }
}
