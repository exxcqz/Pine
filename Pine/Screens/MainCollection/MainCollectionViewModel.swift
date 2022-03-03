//
//  MainCollectionViewModel.swift
//  Pine
//
//  Created by Nikita Gavrikov on 03.03.2022.
//

import Foundation

final class MainCollectionViewModel {

    var imagesData: [ImageData] = []

    init(state: MainCollectionState) {
        self.imagesData = state.imagesData
    }
}
