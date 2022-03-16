//
//  SearchCoordinator.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.03.2022.
//

import UIKit

final class SearchCoordinator: BaseCoordinator<UINavigationController> {

    init(viewController: UINavigationController) {
        super.init(rootViewController: viewController)
    }

    override func start() {
        rootViewController.setViewControllers([SearchViewController()], animated: false)
    }
}
