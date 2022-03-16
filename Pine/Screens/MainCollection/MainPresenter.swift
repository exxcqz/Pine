//
//  MainPresenter.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import Foundation

final class MainPresenter {

    typealias Dependencies = HasMainService

    weak var view: MainViewInput?
    var output: MainModuleOutput?
    var state: MainState
    private let dependencies: Dependencies

    init(state: MainState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    private func fetchRandomData() {
        dependencies.mainService.fetchRandomData(page: state.currentPage) { [weak self] imagesData in
            self?.state.imagesData.append(contentsOf: imagesData)
            self?.state.currentPage += 1
            self?.update(force: false, animated: true)
            print("страница", self?.state.currentPage)
        }
    }
}

//MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {

    func fetchData() {
        update(force: true, animated: false)
        fetchRandomData()
    }

    func nextDetailImageScreen(imageData: ImageData) {
        output?.mainCellTappedEventTriggered(self, imageData: imageData)
    }

    func nextSearchScreen() {
        output?.searchBarTappedEventTriggered(self)
    }
}

//MARK: - MainModuleInput

extension MainPresenter: MainModuleInput {

    func update(force: Bool, animated: Bool) {
        let viewModel = MainViewModel(state: state)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
