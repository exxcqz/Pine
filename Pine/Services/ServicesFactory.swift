//
//  ServicesFactory.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.03.2022.
//

import Foundation

typealias ServicesAlias = HasMainService

var Services: ServicesAlias { // swiftlint:disable:this variable_name
    return MainServicesFactory()
}

final class MainServicesFactory: ServicesAlias {
    lazy var mainService: MainService = MainServiceImp()
}

// MARK: Singletons

private final class SingletonsPool {

}
