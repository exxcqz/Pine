//
//  MainModule.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import UIKit

protocol MainModuleOutput {
    func mainCellTappedEventTriggered(_ moduleInput: MainModuleInput, imageData: ImageData)
}

protocol MainModuleInput: class {
    var state: MainState { get }
    func update(force: Bool, animated: Bool)
}

final class MainModule {
    let viewController: UIViewController
    let presenter: MainPresenter

    var output: MainModuleOutput? {
        didSet {
            presenter.output = output
        }
    }

    var input: MainModuleInput {
        return presenter
    }

    init(state: MainState = .init()) {
        let viewModel = MainViewModel(state: state)
        let presenter = MainPresenter(state: state, dependencies: Services)
        let viewController = MainViewController(viewModel: viewModel, output: presenter)
        presenter.view = viewController
        self.presenter = presenter
        self.viewController = viewController
    }
}
