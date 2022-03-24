//
//  BaseCoordinator.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import UIKit

public protocol Coordinator: AnyObject {
    var delegate: CoordinatorDelegate? { get set }
    func append(child: Coordinator)
    func remove(child: Coordinator)
}

public protocol CoordinatorDelegate: AnyObject {
    func childCoordinatorDidFinish(_ childCoordinator: Coordinator)
}

extension CoordinatorDelegate where Self: Coordinator {
    public func childCoordinatorDidFinish(_ coordinator: Coordinator) {
        remove(child: coordinator)
        coordinator.delegate = nil
    }
}

class BaseCoordinator<V: UIViewController>: NSObject, Coordinator, CoordinatorDelegate {
    public let rootViewController: V
    private var childCoordinators: [Coordinator] = []
    public weak var delegate: CoordinatorDelegate?

    init(rootViewController: V) {
        self.rootViewController = rootViewController
    }

    func start() {}

    func append(child: Coordinator) {
        child.delegate = self
        childCoordinators.append(child)
    }

    func remove(child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return coordinator === child
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
