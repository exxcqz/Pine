//
//  AppCoordinator.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import UIKit

final class AppCoordinator: BaseCoordinator<UINavigationController> {

    private var window: UIWindow?

    init() {
        let navigationController = UINavigationController()
        super.init(rootViewController: navigationController)
    }

    func start(with scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        startMainCoordinator()
    }

    private func startMainCoordinator() {
        let coordinator = MainCoordinator(viewController: rootViewController)
        append(child: coordinator)
        coordinator.start()
    }
}
