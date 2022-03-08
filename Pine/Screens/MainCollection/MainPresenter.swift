//
//  MainPresenter.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import Foundation

final class MainPresenter {
    weak var view: MainViewInput?
    var output: MainModuleOutput?
    var state: MainState
    let mainCellViewModelsFactory: MainCellViewModelsFactory

    init(state: MainState, mainCellViewModelsFactory: MainCellViewModelsFactory) {
        self.state = state
        self.mainCellViewModelsFactory = mainCellViewModelsFactory
    }

    func fetchRandomData() {
        NetworkDataFetch.shared.fetchRandomData(page: state.currentPage) { result, error in
            guard let result = result else { return }
            self.state.imagesData.append(contentsOf: result)
            self.state.currentPage += 1
            if let error = error {
                print(error.localizedDescription)
            }
            self.update(force: false, animated: true)
            print("страница", self.state.currentPage)
        }
    }
}

//MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {

    func fetchData() {
        print("обновляю оутпут")
        update(force: true, animated: false)
        fetchRandomData()
    }

    func nextDetailImageScreen(imageData: ImageData) {
        output?.mainCellTappedEventTriggered(self, imageData: imageData)
    }
}

//MARK: - MainModuleInput

extension MainPresenter: MainModuleInput {

    func update(force: Bool, animated: Bool) {
        let viewModel = MainViewModel(state: state, mainCellViewModelsFactory: mainCellViewModelsFactory)
        print("обновляю в презенторе")
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
