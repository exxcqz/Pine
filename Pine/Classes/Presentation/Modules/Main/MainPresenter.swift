//
//  MainPresenter.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import Foundation
import UIKit

final class MainPresenter {

    typealias Dependencies = HasMainService & HasSearchService

    weak var view: MainViewInput?
    var output: MainModuleOutput?
    var state: MainState
    private let dependencies: Dependencies

    init(state: MainState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    private func fetchRandomData() {
        if !state.isEventScroll {
            dependencies.mainService.fetchRandomData(page: state.currentPage) { [weak self] imagesData, error in
                if error != nil {
                    self?.state.networkConnection = false
                    self?.update(force: false, animated: true)
                    return
                }
                guard let imagesData = imagesData else { return }
                self?.state.networkConnection = true
                self?.state.imagesData.append(contentsOf: imagesData)
                self?.state.currentPage += 1
                self?.update(force: false, animated: true)
            }
            state.isEventScroll = true
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                self.state.isEventScroll = false
            }
        }
    }

    private func fetchSearchData() {
        if !state.isEventScroll {
            guard let query = state.query else { return }
            dependencies.searchService.fetchSearchData(
                query: query,
                page: state.currentPage
            ) { [weak self] result, error in
                if error != nil {
                    self?.state.networkConnection = false
                    self?.update(force: false, animated: true)
                    return
                }
                guard let result = result else { return }
                let imagesData = result.results
                self?.state.networkConnection = true
                self?.state.imagesData.append(contentsOf: imagesData)
                self?.state.currentPage += 1
                self?.state.totalPage = result.totalPages
                self?.update(force: false, animated: true)
            }
        }
        state.isEventScroll = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.state.isEventScroll = false
        }
    }

    private func openSearchScreen() {
        output?.mainSearchBarTappedEventTriggered(self)
    }
}

// MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {
    func selectedImageDataIndex() -> Int? {
        return state.selectedImageDataIndex
    }


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
        CacheManager.cache.removeAllObjects()
        fetchSearchData()
        dependencies.searchService.addQueryToRecent(query: query)
    }

    func nextDetailImageScreen(imageData: ImageData, image: UIImage?) {
        guard let image = image else { return }
        output?.mainCellTappedEventTriggered(self, imageData: imageData, image: image)
    }

    func mainSearchBarTappedEventTriggered() {
        output?.mainSearchBarTappedEventTriggered(self)
    }

    func mainCancelButtonTappedEventTriggered() {
        output?.mainCancelButtonTappedEventTriggered(self)
    }

    func shareButtonTappedEventTriggered(urlImage: String) {
        dependencies.mainService.fetchImage(urlImage: urlImage) { image in
            self.output?.mainShareButtonTappedEventTriggered(self, image: image)
        }
    }
}

// MARK: - MainModuleInput

extension MainPresenter: MainModuleInput {

    func update(force: Bool, animated: Bool) {
        let viewModel = MainViewModel(state: state)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}

// MARK: - MainSectionItemsFactoryOutput

extension MainPresenter: MainSectionItemsFactoryOutput {

    func didSelectImageDataWithIndex(_ index: Int) {
        state.selectedImageDataIndex = index
    }
}
