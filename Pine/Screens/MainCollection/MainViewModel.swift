//
//  MainViewModel.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import Foundation

final class MainViewModel {
    var query: String?
    var searchMode: SearchMode
    var imagesData: [ImageData]
    var currentPage: Int
    var totalPage: Int

    init(state: MainState) {
        self.query = state.query
        self.searchMode = state.searchMode
        self.imagesData = state.imagesData
        self.currentPage = state.currentPage
        self.totalPage = state.totalPage
    }
}
