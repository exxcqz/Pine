//
//  MainCollectionPresenter.swift
//  Pine
//
//  Created by Nikita Gavrikov on 03.03.2022.
//

import Foundation

final class MainCollectionPresenter {

    weak var view: MainCollectionViewInput?
    weak var output: MainCollectionModuleOutput?
    var state: MainCollectionState

    init(state: MainCollectionState) {
        self.state = state
    }

    func fetchRandomData() {
        NetworkDataFetch.shared.fetchRandomData(page: state.currentPage) { result, error in
            guard let result = result else { return }
            self.state.imagesData.append(contentsOf: result)
            self.state.currentPage += 1
            if let error = error {
                print(error.localizedDescription)
            }
        }
        update(force: false, animated: true)
    }
}

//MARK: - MainCollectionViewOutput

extension MainCollectionPresenter: MainCollectionViewOutput {
    func viewDidLoad() {
        fetchRandomData()
    }
}

//MARK: - MainCollectionModuleInput

extension MainCollectionPresenter: MainCollectionModuleInput {

    func update(force: Bool, animated: Bool) {
        let viewModel = MainCollectionViewModel(state: state)
        view?.update(with: viewModel, force: force, animated: animated)

    }
}
