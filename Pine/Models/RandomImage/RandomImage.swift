//
//  RandomImage.swift
//  Pine
//
//  Created by Nikita Gavrikov on 27.02.2022.
//

import Foundation

struct RandomImage: Codable {
    let id: String?
    let width: Int?
    let height: Int?
    let urls: Urls
    let user: UserModel?
}
