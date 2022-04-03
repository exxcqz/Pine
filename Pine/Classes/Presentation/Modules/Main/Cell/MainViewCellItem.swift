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

    private let output: MainViewOutput
    private let imageData: ImageData

    init(imageData: ImageData, output: MainViewOutput) {
        self.imageData = imageData
        self.output = output
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.configureImagesCell(imageInfo: imageData)
        cell.shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }

    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
        return CGSize(
            width: 375 * Layout.scaleFactorW,
            height: 240 * Layout.scaleFactorW
        )
    }

    @objc private func shareButtonTapped() {
        output.shareButtonTappedEventTriggered(urlImage: imageData.urls.regular)
    }
}
