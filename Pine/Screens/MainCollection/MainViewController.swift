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
}

class MainViewController: UIViewController {
    lazy var mainViewManager: CollectionViewManager = .init(collectionView: imagesCollectionView)

    var viewModel: MainViewModel
    var output: MainViewOutput
    
    private let searchController = UISearchController(searchResultsController: nil)
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
        setupSearchController()

        resetMainCollection(imagesData: viewModel.imagesData)
        mainViewManager.sectionItems = [makeMainSectionItem(imagesData: viewModel.imagesData)]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(imagesCollectionView)
    }

    private func setDelegate() {
        mainViewManager.scrollDelegate = self
        searchController.searchBar.delegate = self
    }

    private func setNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        let cancelImage = UIImage(named: Icons.icCross)
        let loupeImage = UIImage(named: Icons.icLoupe)
        searchController.searchBar.setImage(cancelImage, for: .clear, state: .normal)
        searchController.searchBar.setImage(loupeImage, for: .search, state: .normal)
        searchController.searchBar.tintColor = .black
    }

    private func resetMainCollection(imagesData: [ImageData]) {
        mainViewManager.update([makeMainSectionItem(imagesData: imagesData)], shouldReloadData: true) {
            print("Reload complete")
        }
    }

    // MARK: - Factory methods

    func makeMainSectionItem(imagesData: [ImageData]) -> CollectionViewSectionItem {
        let sectionItem = MainSectionItem()
        var cellItems: [CollectionViewCellItem] = imagesData.map { imageData in
            makeCellItem(imageData: imageData)
        }
        cellItems.append(makeIndicatorCellItem())
        sectionItem.cellItems = cellItems
        sectionItem.minimumLineSpacing = 4
        return sectionItem
    }

    private func makeCellItem(imageData: ImageData) -> MainViewCellItem {
        let cellItem = MainViewCellItem(imageData: imageData)
        return cellItem
    }

    private func makeIndicatorCellItem() -> MainIndicatorViewCellItem {
        let cellItem = MainIndicatorViewCellItem()
        return cellItem
    }
}

//// MARK: - UICollectionViewDelegate
//
//extension MainViewController: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == cellViewModels.count && viewModel.currentPage < viewModel.totalPage {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.output.fetchData()
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row != cellViewModels.count {
//            //            let imageViewController = DetailImageViewController()
//            //            let mainCellViewModel = cellViewModels[indexPath.row]
//            //            let imageData = mainCellViewModel.imageData
//            //            imageViewController.setImage(imageInfo: imageData)
//            //            navigationController?.pushViewController(imageViewController, animated: true)
//
//            let mainCellViewModel = cellViewModels[indexPath.row]
//            let imageData = mainCellViewModel.imageData
//            output.nextDetailImageScreen(imageData: imageData)
//        }
//    }
//}

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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
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
    }
}
