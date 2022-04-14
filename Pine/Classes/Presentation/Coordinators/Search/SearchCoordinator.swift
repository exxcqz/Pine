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
        let searchModule = SearchModule()
        searchModule.output = self
        rootViewController.pushViewController(searchModule.viewController, animated: true)
    }

    private func startMainCoordinator(query: String) {
        let coordinator = MainCoordinator(viewController: rootViewController, query: query)
        remove(child: self)
        append(child: coordinator)
        coordinator.start()
    }
}

// MARK: - SearchModuleOutput

extension SearchCoordinator: SearchModuleOutput {

    func searchCancelButtonEventTriggered(_ moduleInput: SearchModuleInput) {
        rootViewController.delegate = nil
        rootViewController.popViewController(animated: true)
    }

    func searchButtonEventTriggered(_ moduleInput: SearchModuleInput, query: String) {
        startMainCoordinator(query: query)
    }
}
