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
    var imageFullScreen: Bool = true

    init(imageData: ImageData?) {
        self.imageData = imageData
    }
}
