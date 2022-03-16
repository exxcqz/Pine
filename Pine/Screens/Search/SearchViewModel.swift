//
//  SearchViewModel.swift
//  Pine
//
//  Created by Nikita Gavrikov on 16.03.2022.
//

import Foundation

final class SearchViewModel {
    var recentSearches: [String]

    init(state: SearchState) {
        self.recentSearches = state.recentSearches
    }
}
