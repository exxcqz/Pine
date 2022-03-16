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
    }

    private func addQueryToRecent(query: String) {
        state.recentSearches.append(query)
        update(force: false, animated: false)
    }

}

//MARK: - SearchViewOutput

extension SearchPresenter: SearchViewOutput {

    func viewDidLoad() {
    }

    func clearRecentSearches() {
        state.recentSearches.removeAll()
        update(force: false, animated: false)
    }

    func searchCancelButtonEventTriggered() {
        output?.searchCancelButtonEventTriggered(self)
    }

    func fetchDataOnQuery(query: String) {
        addQueryToRecent(query: query)
    }
}

//MARK: - SearchModuleInput

extension SearchPresenter: SearchModuleInput {

    func update(force: Bool, animated: Bool) {
        let viewModel = SearchViewModel(state: state)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
