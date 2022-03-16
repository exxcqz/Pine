//
//  SearchModule.swift
//  Pine
//
//  Created by Nikita Gavrikov on 16.03.2022.
//

import UIKit

protocol SearchModuleOutput {
    func searchCancelButtonEventTriggered(_ moduleInput: SearchModuleInput)
}

protocol SearchModuleInput: class {
    var state: SearchState { get }
    func update(force: Bool, animated: Bool)
}

final class SearchModule {

        let viewController: UIViewController
        let presenter: SearchPresenter

        var output: SearchModuleOutput? {
            didSet {
                presenter.output = output
            }
        }

        var input: SearchModuleInput {
            return presenter
        }

        init(state: SearchState = .init()) {
            let viewModel = SearchViewModel(state: state)
            let presenter = SearchPresenter(state: state)
            let viewController = SearchViewController(viewModel: viewModel, output: presenter)
            presenter.view = viewController
            self.presenter = presenter
            self.viewController = viewController
        }

}
