//
//  SearchPresenter.swift
//  Pine
//
//  Created by Nikita Gavrikov on 16.03.2022.
//

import Foundation

final class SearchPresenter {

    typealias Dependencies = HasSearchService

    weak var view: SearchViewInput?
    var output: SearchModuleOutput?
    var state: SearchState
    private let dependencies: Dependencies

    init(state: SearchState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
        dependencies.searchService.createDataBaseForRecentSearches()
    }
}

// MARK: - SearchViewOutput

extension SearchPresenter: SearchViewOutput {

    func updateRecentSearches() {
        state.updateRecentSearches()
        update(force: false, animated: false)
    }

    func clearRecentSearches() {
        dependencies.searchService.clearRecentSearches()
        state.updateRecentSearches()
        update(force: false, animated: false)
    }

    func searchCancelButtonEventTriggered() {
        output?.searchCancelButtonEventTriggered(self)
    }

    func searchButtonEventTriggered(query: String) {
        dependencies.searchService.addQueryToRecent(query: query)
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
