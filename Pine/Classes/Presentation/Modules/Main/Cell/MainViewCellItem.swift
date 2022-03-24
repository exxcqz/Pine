//
//  MainViewCellItem.swift
//  Pine
//
//  Created by Nikita Gavrikov on 10.03.2022.
//

import UIKit
import CollectionViewTools

final class MainViewCellItem: CollectionViewCellItem {

    typealias Cell = MainViewCell
    private(set) var reuseType: ReuseType = .class(Cell.self)

    private let imageData: ImageData
    weak var viewController: UIViewController?

    init(imageData: ImageData, viewController: UIViewController?) {
        self.imageData = imageData
        self.viewController = viewController
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.configureImagesCell(imageInfo: imageData)
        cell.shareButton.addTarget(self, action: #selector(openShareController), for: .touchUpInside)
    }

    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
        return CGSize(
            width: 375 * Layout.scaleFactorW,
            height: 240 * Layout.scaleFactorW
        )
    }

    @objc private func openShareController() {
        NetworkDataFetch.shared.fetchImage(urlImage: imageData.urls.regular) { image in
            let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.viewController?.present(shareController, animated: true, completion: nil)
        }
    }
}
