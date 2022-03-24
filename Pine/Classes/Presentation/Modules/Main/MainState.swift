//
//  MainState.swift
//  Pine
//
//  Created by Nikita Gavrikov on 04.03.2022.
//

import UIKit

enum SearchMode {
    case random
    case query
}

final class MainState {
    var query: String?
    var searchMode: SearchMode = .random
    var imagesData: [ImageData] = []
    var currentPage: Int = 1
    var totalPage: Int = 50
    var networkConnection: Bool = true
    var isEventScroll: Bool = false

    init(query: String?) {
        self.query = query
    }
}
