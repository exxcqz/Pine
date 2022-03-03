//
//  MainCollectionViewState.swift
//  Pine
//
//  Created by Nikita Gavrikov on 03.03.2022.
//

import UIKit

final class MainCollectionState {
    var imagesData: [ImageData] = []
    var query: String = ""
    var currentPage: Int = 1
    var totalPage: Int = 50
    let scaleWidth = UIScreen.main.bounds.size.width / 375
}
