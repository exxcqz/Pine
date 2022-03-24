//
//  SearchPresenter.swift
//  Pine
//
//  Created by Nikita Gavrikov on 16.03.2022.
//

import Foundation

final class SearchPresenter {
    weak var view: SearchViewInput?
    var output: SearchModuleOutput?
    var state: SearchState

    init(state: SearchState) {
        self.state = state
        createDataBaseForRecentSearches()
    }

    private func createDataBaseForRecentSearches() {
        let recentSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String]
        if recentSearches == nil {
            let array: [String] = []
            print("sozdal")
            UserDefaults.standard.set(array, forKey: "recentSearches")
        }
    }

    private func addQueryToRecent(query: String) {
        guard var recentSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String] else { return }
        if recentSearches.contains(query) {
            guard let index = recentSearches.firstIndex(of: query) else { return }
            recentSearches.remove(at: index)
        }
        recentSearches.append(query)
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
        state.updateRecentSearches()
        update(force: false, animated: false)
    }
}

// MARK: - SearchViewOutput

extension SearchPresenter: SearchViewOutput {

    func updateRecentSearches() {
        state.updateRecentSearches()
        update(force: false, animated: false)
    }

    func clearRecentSearches() {
        guard var recentSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String] else { return }
        recentSearches.removeAll()
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
        state.updateRecentSearches()
        update(force: false, animated: false)
    }

    func searchCancelButtonEventTriggered() {
        output?.searchCancelButtonEventTriggered(self)
    }

    func searchButtonEventTriggered(query: String) {
        addQueryToRecent(query: query)
        output?.searchButtonEventTriggered(self, query: query)
    }
}

// MARK: - SearchModuleInput

extension SearchPresenter: SearchModuleInput {

    func update(force: Bool, animated: Bool) {
        let viewModel = SearchViewModel(state: state)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
