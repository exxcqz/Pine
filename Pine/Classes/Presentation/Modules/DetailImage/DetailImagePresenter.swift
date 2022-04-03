//
//  DetailImagePresenter.swift
//  Pine
//
//  Created by Nikita Gavrikov on 08.03.2022.
//

import Foundation

final class DetailImagePresenter {
    weak var view: DetailImageViewInput?
    var output: DetailImageModuleOutput?
    var state: DetailImageState

    init(state: DetailImageState) {
        self.state = state
    }

    private func setDetailImage() {
        guard let imageData = state.imageData else { return }
        state.nameUser = "\(imageData.user?.firstName ?? "") \(imageData.user?.lastName ?? "")"
        let url = imageData.urls.regular
        NetworkDataFetch.shared.fetchImage(urlImage: url) { image in
            self.state.image = image
            if imageData.width < imageData.height {
                self.state.imageFullScreen = true
            } else {
                self.state.imageFullScreen = false
            }
            self.update(force: false, animated: true)
        }
    }
}

// MARK: - DetailImageViewOutput

extension DetailImagePresenter: DetailImageViewOutput {

    func viewDidLoad() {
        setDetailImage()
    }
}

// MARK: - DetailImageModuleInput

extension DetailImagePresenter: DetailImageModuleInput {

    func update(force: Bool, animated: Bool) {
        let viewModel = DetailImageViewModel(state: state)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
