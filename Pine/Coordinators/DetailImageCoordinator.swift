//
//  DetailImageCoordinator.swift
//  Pine
//
//  Created by Nikita Gavrikov on 08.03.2022.
//

import UIKit

final class DetailImageCoordinator: BaseCoordinator<UINavigationController> {
    let imageData: ImageData

    init(imageData: ImageData, viewController: UINavigationController) {
        self.imageData = imageData
        super.init(rootViewController: viewController)
    }

    override func start() {
        let detailImageModule = DetailImageModule(imageData: imageData)
        detailImageModule.output = self
        rootViewController.pushViewController(detailImageModule.viewController, animated: true)
    }
}

// MARK: - DetailImageModuleOutput

extension DetailImageCoordinator: DetailImageModuleOutput {

    func detailImageModuleEventTriggered(_ moduleInput: DetailImageModuleInput) {

    }
}
