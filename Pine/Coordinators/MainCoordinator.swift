//
//  MainCoordinator.swift
//  Pine
//
//  Created by Nikita Gavrikov on 07.03.2022.
//

import UIKit

final class MainCoordinator: BaseCoordinator<UINavigationController> {

    init(viewController: UINavigationController) {
        super.init(rootViewController: viewController)
    }

    override func start() {
        let mainModule = MainModule()
        mainModule.output = self
        rootViewController.setViewControllers([mainModule.viewController], animated: true)
    }

    private func startDetailImageCoordinator(imageData: ImageData) {
        let coordinator = DetailImageCoordinator(imageData: imageData, viewController: rootViewController)
        remove(child: self)
        append(child: coordinator)
        coordinator.start()
    }
}

// MARK: - MainModuleOutput

extension MainCoordinator: MainModuleOutput {
    
    func mainCellTappedEventTriggered(_ moduleInput: MainModuleInput, imageData: ImageData) {
        startDetailImageCoordinator(imageData: imageData)
    }
}
