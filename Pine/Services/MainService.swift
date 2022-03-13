//
//  MainService.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.03.2022.
//

import Foundation

protocol HasMainService {
    var mainService: MainService { get }
}

protocol MainService {
    func fetchRandomData(page: Int, completion: @escaping ([ImageData]) -> Void)
}
