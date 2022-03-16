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
}

//MARK: - SearchModuleOutput

extension SearchCoordinator: SearchModuleOutput {
    
    func searchCancelButtonEventTriggered(_ moduleInput: SearchModuleInput) {
        rootViewController.popViewController(animated: true)
    }
}
