//
//  SearchState.swift
//  Pine
//
//  Created by Nikita Gavrikov on 16.03.2022.
//

import Foundation

final class SearchState {
    var recentSearches: [String] = []

    func updateRecentSearches() {
        guard let recentSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String] else { return }
        self.recentSearches = recentSearches
        self.recentSearches.reverse()
    }

    init() {
        updateRecentSearches()
    }
}
