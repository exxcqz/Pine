//
//  MainPresenter.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import Foundation

final class MainPresenter {

    typealias Dependencies = HasMainService

    weak var view: MainViewInput?
    var output: MainModuleOutput?
    var state: MainState
    private let dependencies: Dependencies

    init(state: MainState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    private func fetchRandomData() {
        dependencies.mainService.fetchRandomData(page: state.currentPage) { [weak self] imagesData in
            self?.state.imagesData.append(contentsOf: imagesData)
            self?.state.currentPage += 1
            self?.update(force: false, animated: true)
            print("страница", self?.state.currentPage)
        }
    }

    private func fetchSearchData() {
        guard let query = state.query else { return print("search error") }
        dependencies.mainService.fetchSearchData(query: query, page: state.currentPage) { [weak self] result in
            let imagesData = result.results
            self?.state.imagesData.append(contentsOf: imagesData)
            self?.state.currentPage += 1
            self?.state.totalPage = result.totalPages
            self?.update(force: false, animated: true)
            print("страница", self?.state.currentPage)
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
    }

    private func openSearchScreen() {
        output?.mainSearchBarTappedEventTriggered(self)
    }
}

//MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {

    func fetchData() {
        switch state.searchMode {
        case .random:
            fetchRandomData()
        case .query:
            fetchSearchData()
        }
    }

    func fetchSearchData(query: String) {
        state.currentPage = 1
        state.query = query
        state.imagesData.removeAll()
        fetchSearchData()
        addQueryToRecent(query: query)
    }

    func nextDetailImageScreen(imageData: ImageData) {
        output?.mainCellTappedEventTriggered(self, imageData: imageData)
    }

    func mainSearchBarTappedEventTriggered() {
        output?.mainSearchBarTappedEventTriggered(self)
    }


    func mainCancelButtonTappedEventTriggered() {
        output?.mainCancelButtonTappedEventTriggered(self)
    }
}

//MARK: - MainModuleInput

extension MainPresenter: MainModuleInput {

    func update(force: Bool, animated: Bool) {
        let viewModel = MainViewModel(state: state)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
