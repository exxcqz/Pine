//
//  DetailImageViewModel.swift
//  Pine
//
//  Created by Nikita Gavrikov on 08.03.2022.
//

import UIKit

final class DetailImageViewModel {
    var imageData: ImageData?
    var image: UIImage?
    var nameUser: String = ""

    init(state: DetailImageState) {
        self.imageData = state.imageData
        self.image = state.image
        self.nameUser = state.nameUser
    }
}
