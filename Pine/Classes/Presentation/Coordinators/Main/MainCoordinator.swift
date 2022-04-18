//
//  MainCoordinator.swift
//  Pine
//
//  Created by Nikita Gavrikov on 07.03.2022.
//

import UIKit

final class MainCoordinator: BaseCoordinator<UINavigationController> {
    let query: String?

    init(viewController: UINavigationController, query: String? = nil) {
        self.query = query
        super.init(rootViewController: viewController)
    }

    override func start() {
        if let query = query {
            let mainState = MainState(query: query)
            mainState.searchMode = .query
            let mainModule = MainModule(state: mainState)
            mainModule.output = self
            rootViewController.pushViewController(mainModule.viewController, animated: true)
            return
        }
        let mainModule = MainModule()
        mainModule.output = self
        rootViewController.setViewControllers([mainModule.viewController], animated: true)
    }

    private func startDetailImageCoordinator(imageData: ImageData, image: UIImage) {
        let coordinator = DetailImageCoordinator(imageData: imageData, image: image, viewController: rootViewController)
        remove(child: self)
        append(child: coordinator)
        coordinator.start()
    }

    private func startSearchCoordinator() {
        rootViewController.delegate = nil
        let coordinator = SearchCoordinator(viewController: rootViewController)
        remove(child: self)
        append(child: coordinator)
        coordinator.start()
    }

    private func openShareController(image: UIImage) {
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        rootViewController.present(shareController, animated: true, completion: nil)
    }
}

// MARK: - MainModuleOutput

extension MainCoordinator: MainModuleOutput {

    func mainCellTappedEventTriggered(_ moduleInput: MainModuleInput, imageData: ImageData, image: UIImage) {
        startDetailImageCoordinator(imageData: imageData, image: image)
    }

    func mainSearchBarTappedEventTriggered(_ moduleInput: MainModuleInput) {
        startSearchCoordinator()
    }

    func mainCancelButtonTappedEventTriggered(_ moduleInput: MainModuleInput) {
        rootViewController.delegate = nil
        rootViewController.popViewController(animated: true)
    }

    func mainShareButtonTappedEventTriggered(_ moduleInput: MainModuleInput, image: UIImage) {
        openShareController(image: image)
    }
}

// MARK: - UINavigationControllerDelegate

extension MainViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .none:
            return nil
        case .push:
            return MainTransitionManagerForPresent()
        case .pop:
            return MainTransitionManagerForDismiss()
        @unknown default:
            return nil
        }
    }
}
