//
//  MainService.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.03.2022.
//

import Foundation
import UIKit

protocol HasMainService {
    var mainService: MainService { get }
}

protocol MainService {
    func fetchRandomData(page: Int, completion: @escaping ([ImageData]?, Error?) -> Void)
    func fetchImage(urlImage: String, completion: @escaping (UIImage) -> Void)
}
