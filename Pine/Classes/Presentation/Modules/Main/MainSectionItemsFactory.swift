//
//  MainSectionItemsFactory.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.04.2022.
//

import Foundation
import CollectionViewTools

protocol MainSectionItemsFactoryOutput {
    func didSelectImageDataWithIndex(_ index: Int)
}

final class MainSectionItemsFactory {

    private var output: MainPresenter

    init(output: MainPresenter) {
        self.output = output
    }

    func makeMainSectionItem(imagesData: [ImageData]) -> CollectionViewSectionItem {
        let sectionItem = GeneralCollectionViewSectionItem()
        var cellItems: [CollectionViewCellItem] = imagesData.map { imageData in
            makeCellItem(imageData: imageData)
        }
        if cellItems.count > 0 && output.state.currentPage < output.state.totalPage {
            cellItems.append(makeIndicatorCellItem())
        }
        sectionItem.cellItems = cellItems
        sectionItem.minimumLineSpacing = 4 * Layout.scaleFactorW
        return sectionItem
    }

    func makeCellItem(imageData: ImageData) -> MainViewCellItem {
        let cellItem = MainViewCellItem(imageData: imageData, output: output)
        cellItem.itemDidSelectHandler = { indexPath in
            let cell = cellItem.cell as? MainViewCell
            self.output.didSelectImageDataWithIndex(indexPath.row)
            self.output.nextDetailImageScreen(imageData: imageData, image: cell?.imageView.image)
        }
        return cellItem
    }

    func makeIndicatorCellItem() -> MainIndicatorViewCellItem {
        let cellItem = MainIndicatorViewCellItem(networkConnection: output.state.networkConnection)
        if !output.state.networkConnection {
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                self.output.fetchData()
            }
        }
        return cellItem
    }
}
