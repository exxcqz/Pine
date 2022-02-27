//
//  CacheManager.swift
//  Pine
//
//  Created by Nikita Gavrikov on 27.02.2022.
//

import Foundation

class CacheManager {
    static let cache = NSCache<AnyObject, AnyObject>()

    private init() {}
}
