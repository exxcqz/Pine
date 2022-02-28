//
//  SearchResult.swift
//  Pine
//
//  Created by Nikita Gavrikov on 27.02.2022.
//

import Foundation

struct SearchResult: Codable {
    let total: Int
    let totalPages: Int
    let results: [ImageData]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
