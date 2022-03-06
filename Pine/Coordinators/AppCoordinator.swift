//
//  AppCoordinator.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import UIKit

final class AppCoordinator: BaseCoordinator<UINavigationController> {

    var window: UIWindow?

    init() {
        let module = MainModule()
        super.init(rootViewController: UINavigationController(rootViewController: module.viewController))
    }

    override func start() {
        window = UIWindow()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        let module = makeMainCollectionModule()
        rootViewController.setViewControllers([module.viewController], animated: false)
    }

    //MARK: - Private

    private func showNextScreen() {
        let module = MainModule()
        rootViewController.pushViewController(module.viewController, animated: true)
    }

    private func makeMainCollectionModule() -> MainModule {
        let module = MainModule()
        return module
    }
}

// MARK: - MainModuleOutput

extension AppCoordinator: MainModuleOutput {
    
    func exampleModuleEventTriggered(_ moduleInput: MainModuleInput) {
        showNextScreen()
    }
}
