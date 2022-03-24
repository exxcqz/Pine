//
//  MainIndicatorViewCellItem.swift
//  Pine
//
//  Created by Nikita Gavrikov on 12.03.2022.
//

import UIKit
import CollectionViewTools

final class MainIndicatorViewCellItem: CollectionViewCellItem {

    typealias Cell = MainIndicatorViewCell
    private(set) var reuseType: ReuseType = .class(Cell.self)
    private let networkConnection: Bool

    init(networkConnection: Bool) {
        self.networkConnection = networkConnection
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.activityIndicator.startAnimating()
        cell.labelNoConnection.isHidden = networkConnection
    }

    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
        return CGSize(
            width: 375 * Layout.scaleFactorW,
            height: 83 * Layout.scaleFactorW
        )
    }
}
