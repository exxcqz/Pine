//
//  MainViewModel.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import Foundation

final class MainViewModel {
    var imagesData: [ImageData]
    var query: String
    var currentPage: Int
    var totalPage: Int

    init(state: MainState) {
        self.query = state.query
        self.currentPage = state.currentPage
        self.totalPage = state.totalPage
        self.imagesData = state.imagesData
    }
}
