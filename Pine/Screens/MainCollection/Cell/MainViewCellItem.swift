//
//  MainViewCellItem.swift
//  Pine
//
//  Created by Nikita Gavrikov on 10.03.2022.
//

import UIKit
import CollectionViewTools

class MainViewCellItem: CollectionViewCellItem {

    typealias Cell = MainCollectionViewCell
    private(set) var reuseType: ReuseType = .class(Cell.self)

    private let imageData: ImageData

    init(imageData: ImageData) {
        self.imageData = imageData
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.configureImagesCell(imageInfo: imageData)
    }

    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
        return CGSize(width: 375, height: 240)
    }
}
