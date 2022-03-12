////
////  MainViewController.swift
////  Pine
////
////  Created by Nikita Gavrikov on 04.03.2022.
////
//
//import UIKit
//
//protocol MainViewInput: class {
//    func update(with viewModel: MainViewModel, force: Bool, animated: Bool)
//}
//
//protocol MainViewOutput: class {
//    func fetchData()
//    func nextDetailImageScreen(imageData: ImageData)
//}
//
//class MainViewController: UIViewController {
//    var viewModel: MainViewModel
//    var output: MainViewOutput
//
//    private let searchController = UISearchController(searchResultsController: nil)
//    private var imagesCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 5
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.bounces = false
//        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.register(IndicatorViewCell.self, forCellWithReuseIdentifier: "indicator")
//        collectionView.keyboardDismissMode = .onDrag
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//
//    var cellViewModels: [MainCellViewModel] = []
//
//    init(viewModel: MainViewModel, output: MainViewOutput) {
//        self.viewModel = viewModel
//        self.output = output
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        setDelegate()
//        setConstraints()
//        setNavigationBar()
//        setupSearchController()
//        output.fetchData()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        navigationController?.navigationBar.barStyle = .default
//    }
//
//    private func setupViews() {
//        view.backgroundColor = .white
//        view.addSubview(imagesCollectionView)
//    }
//
//    private func setDelegate() {
//        imagesCollectionView.delegate = self
//        imagesCollectionView.dataSource = self
//        searchController.searchBar.delegate = self
//    }
//
//    private func setNavigationBar() {
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//    }
//
//    private func setupSearchController() {
//        searchController.searchBar.placeholder = "Search"
//        searchController.obscuresBackgroundDuringPresentation = false
//        let cancelImage = UIImage(named: Icons.icCross)
//        let loupeImage = UIImage(named: Icons.icLoupe)
//        searchController.searchBar.setImage(cancelImage, for: .clear, state: .normal)
//        searchController.searchBar.setImage(loupeImage, for: .search, state: .normal)
//        searchController.searchBar.tintColor = .black
//    }
//
//    private func createIndicator() -> UIView {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
//        let indicator = UIActivityIndicatorView()
//        indicator.center = view.center
//        view.addSubview(indicator)
//        indicator.startAnimating()
//        return view
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//
//extension MainViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return (cellViewModels.count > 0) ? (cellViewModels.count + 1) : 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row != cellViewModels.count {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
//            let mainCellViewModel = cellViewModels[indexPath.row]
//            cell.configureImagesCell(imageInfo: mainCellViewModel.imageData)
//            return cell
//        } else {
//            let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "indicator", for: indexPath) as! IndicatorViewCell
//            indicatorCell.activityIndicator.startAnimating()
//            return indicatorCell
//        }
//    }
//}
//
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
////            let imageViewController = DetailImageViewController()
////            let mainCellViewModel = cellViewModels[indexPath.row]
////            let imageData = mainCellViewModel.imageData
////            imageViewController.setImage(imageInfo: imageData)
////            navigationController?.pushViewController(imageViewController, animated: true)
//
//            let mainCellViewModel = cellViewModels[indexPath.row]
//            let imageData = mainCellViewModel.imageData
//            output.nextDetailImageScreen(imageData: imageData)
//        }
//    }
//}
//
////// MARK: - UIScrollViewDelegate
////
////extension MainViewController: UIScrollViewDelegate {
////
////    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        let offset = scrollView.contentOffset.y
////        let contentHeight = scrollView.contentSize.height
////        print(offset, contentHeight, scrollView.frame.height)
////        if offset > (contentHeight - scrollView.frame.height) && viewModel.currentPage < viewModel.totalPage {
////            output.fetchData()
////        }
////    }
////}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//
//extension MainViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = imagesCollectionView.frame.size
//        let cellHeight = (indexPath.row == cellViewModels.count && viewModel.currentPage < viewModel.totalPage) ? 50 : 240
//        return CGSize(width: size.width , height: CGFloat(cellHeight) * Layout.scaleFactorW)
//    }
//}
//
//// MARK: - UISearchBarDelegate
//
//extension MainViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//    }
//}
//
//// MARK: - MainViewInput
//
//extension MainViewController: MainViewInput {
//
//    func update(with viewModel: MainViewModel, force: Bool, animated: Bool) {
//        self.viewModel = viewModel
//        cellViewModels = viewModel.cellViewModels
//        imagesCollectionView.reloadData()
//    }
//}
//
//// MARK: - SetConstraints
//
//extension MainViewController {
//
//    private func setConstraints() {
//        imagesCollectionView.frame = view.bounds
//    }
//}
//
