//
//  MainModule.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import UIKit

protocol MainModuleOutput {
    func mainCellTappedEventTriggered(_ moduleInput: MainModuleInput, imageData: ImageData, image: UIImage)
    func mainSearchBarTappedEventTriggered(_ moduleInput: MainModuleInput)
    func mainCancelButtonTappedEventTriggered(_ moduleInput: MainModuleInput)
    func mainShareButtonTappedEventTriggered(_ moduleInput: MainModuleInput, image: UIImage)
}

protocol MainModuleInput: class {
    var state: MainState { get }
    func update(force: Bool, animated: Bool)
}

final class MainModule {
    let viewController: MainViewController
    let presenter: MainPresenter

    var output: MainModuleOutput? {
        didSet {
            presenter.output = output
        }
    }

    var input: MainModuleInput {
        return presenter
    }

    init(state: MainState = .init(query: nil)) {
        let viewModel = MainViewModel(state: state)
        let presenter = MainPresenter(state: state, dependencies: Services)
        let viewController = MainViewController(viewModel: viewModel, output: presenter)
        presenter.view = viewController
        self.presenter = presenter
        self.viewController = viewController
    }
}
