//
//  AppCoordinator.swift
//  Pine
//
//  Created by Nikita Gavrikov on 02.03.2022.
//

import UIKit

final class AppCoordinator: BaseCoordinator<UINavigationController> {

    var window: UIWindow?

    init() {
        let module = MainCollectionModule()
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
        let module = MainCollectionModule()
        rootViewController.pushViewController(module.viewController, animated: true)
    }

    private func makeMainCollectionModule() -> MainCollectionModule {
        let module = MainCollectionModule()
        return module
    }
}

extension AppCoordinator: MainCollectionModuleOutput {

    func mainCollectionModuleClosed(_ moduleInput: MainCollectionModuleInput) {
    }

    func mainCollectionModuleShowNextScreenEventTriggered(_ moduleInput: MainCollectionModuleInput) {
        showNextScreen()
    }
}
