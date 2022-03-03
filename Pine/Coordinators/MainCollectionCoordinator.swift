////
////  MainCollectionCoordinator.swift
////  Pine
////
////  Created by Nikita Gavrikov on 02.03.2022.
////
//
//import UIKit
//
//protocol RegistrationCoordinatorOutput: class {
//    func registrationCoordinatorRegistrationFinishedEventTriggered(_ coordinator: RegistrationCoordinator)
//    func registrationCoordinatorRegistrationSkippedEventTriggered(_ coordinator: RegistrationCoordinator)
//}
//
//final class RegistrationCoordinator: BaseCoordinator<UINavigationController> {
//    
//    enum PresentationStyle {
//        case modal
//        case root
//    }
//
//    weak var output: RegistrationCoordinatorOutput?
//
//    private let presentationStyle: PresentationStyle
//
//    init(presentationStyle: PresentationStyle, rootViewController:
//         UINavigationController) {
//        self.presentationStyle = presentationStyle
//        super.init(rootViewController: rootViewController)
//    }
//
//    override func start() {
//        let registrationModule = RegistrationModule()
//        registrationModule.output = self
//        switch presentationStyle {
//        case .root:
//            rootViewController.setViewControllers([registrationModule.
//                                                   viewController], animated: false)
//        case .modal:
//            rootViewController.present(registrationModule.
//                                       viewController, animated: true)
//        }
//    }
//}
//extension RegistrationCoordinator: RegistrationModuleOutput {
//    func registrationModuleRegistrationFinishedEventTriggered(_
//                                                              moduleInput: RegistrationModuleInput) {
//        output?.
//        registrationCoordinatorRegistrationFinishedEventTriggered(self)
//        delegate?.childCoordinatorDidFinish(self)
//
//    }
//    func registrationModuleRegistrationSkippedEventTriggered(_
//                                                             moduleInput: RegistrationModuleInput) {
//        output?.registrationCoordinatorRegistrationSkippedEventTriggered
//        (self)
//        delegate?.childCoordinatorDidFinish(self)
//    }
//}
