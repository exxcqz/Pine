//
//  MainCellViewModelFactory.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import Foundation


final class MainCellViewModelsFactory {
    weak var viewController: MainViewController?
    weak var output: MainViewOutput?

    func makeViewModels(state: MainState) -> [MainCellViewModel] {
        return state.imagesData.map { imageData in
            MainCellViewModel(imageData: imageData)
        }
    }
}
