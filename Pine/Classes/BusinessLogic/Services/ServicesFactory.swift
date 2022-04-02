//
//  ServicesFactory.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.03.2022.
//

import Foundation

typealias ServicesAlias = HasMainService & HasSearchService

var Services: ServicesAlias { // swiftlint:disable:this variable_name
    return ServicesFactory()
}

final class ServicesFactory: ServicesAlias {
    lazy var searchService: SearchService = SearchServiceImp()
    lazy var mainService: MainService = MainServiceImp()
}

// MARK: Singletons

private final class SingletonsPool {

}
