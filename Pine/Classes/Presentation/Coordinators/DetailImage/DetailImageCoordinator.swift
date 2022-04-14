//
//  DetailImageCoordinator.swift
//  Pine
//
//  Created by Nikita Gavrikov on 08.03.2022.
//

import UIKit

final class DetailImageCoordinator: BaseCoordinator<UINavigationController> {
    let imageData: ImageData
    private let image: UIImage?

    init(imageData: ImageData, image: UIImage, viewController: UINavigationController) {
        self.imageData = imageData
        self.image = image
        super.init(rootViewController: viewController)
    }

    override func start() {
        let detailImageState = DetailImageState(imageData: imageData, image: image)
        let detailImageModule = DetailImageModule(state: detailImageState)
        detailImageModule.output = self
        rootViewController.pushViewController(detailImageModule.viewController, animated: true)
    }
}

// MARK: - DetailImageModuleOutput

extension DetailImageCoordinator: DetailImageModuleOutput {

    func detailImageModuleEventTriggered(_ moduleInput: DetailImageModuleInput) {

    }
}
