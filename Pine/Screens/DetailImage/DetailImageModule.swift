//
//  DetailImageModule.swift
//  Pine
//
//  Created by Nikita Gavrikov on 08.03.2022.
//

import UIKit

protocol DetailImageModuleOutput {
    func detailImageModuleEventTriggered(_ moduleInput: DetailImageModuleInput)
}

protocol DetailImageModuleInput: class {
    var state: DetailImageState { get }
    func update(force: Bool, animated: Bool)
}

final class DetailImageModule {
    let viewController: UIViewController
    let presenter: DetailImagePresenter

    var output: DetailImageModuleOutput? {
        didSet {
            presenter.output = output
        }
    }

    var input: DetailImageModuleInput {
        return presenter
    }

    init(state: DetailImageState = .init(imageData: nil)) {
        let viewModel = DetailImageViewModel(state: state)
        let presenter = DetailImagePresenter(state: state)
        let viewController = DetailImageViewController(viewModel: viewModel, output: presenter)
        presenter.view = viewController
        self.presenter = presenter
        self.viewController = viewController
    }
}

