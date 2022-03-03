//
//  MainCollectionModule.swift
//  Pine
//
//  Created by Nikita Gavrikov on 03.03.2022.
//

import Foundation

protocol MainCollectionModuleInput: class {
    var state: MainCollectionState { get }
    func update(force: Bool, animated: Bool)
}

protocol MainCollectionModuleOutput: class {
    func mainCollectionModuleClosed(_ moduleInput: MainCollectionModuleInput)
    func mainCollectionModuleShowNextScreenEventTriggered(_ moduleInput: MainCollectionModuleInput)
}

final class MainCollectionModule {
    let viewController: MainCollectionViewController
    let presenter: MainCollectionPresenter

    var input: MainCollectionModuleInput {
        return presenter
    }

    var output: MainCollectionModuleOutput? {
        didSet {
            presenter.output = output
        }
    }

    init(state: MainCollectionState = .init()) {
        presenter = MainCollectionPresenter(state: state)
        viewController = MainCollectionViewController(output: presenter)
    }
}
