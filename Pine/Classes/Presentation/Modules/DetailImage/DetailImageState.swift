//
//  DetailImageState.swift
//  Pine
//
//  Created by Nikita Gavrikov on 08.03.2022.
//

import UIKit

final class DetailImageState {
    var imageData: ImageData?
    var image: UIImage?
    var nameUser: String = ""

    init(imageData: ImageData?, image: UIImage?) {
        self.imageData = imageData
        self.image = image
    }
}
