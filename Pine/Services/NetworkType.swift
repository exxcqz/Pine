//
//  File.swift
//  Pine
//
//  Created by Nikita Gavrikov on 27.02.2022.
//

import Foundation

enum NetworkType {
    case getRandomImage(page: Int)
    case getSearchImage(query: String, page: Int)

    var baseURL: URL {
        return URL(string: "https://api.unsplash.com/")!
    }

    var headers: [String: String] {
        return ["Authorization": "Client-ID 9C3O-Dt7AQEgrcVKBPwUpynL1z3x0uZCbUM-UTr1how"]
    }

    var path: String {
        switch self {
        case .getSearchImage(let query, let page):
            var path = "search/photos"
            guard
                let query = query.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            else {
                return path
            }
            path = "search/photos?per_page=30&page=\(page)&query=\(query)"
            return path
        case .getRandomImage(let page):
            return "photos?page=\(page)"
        }
    }

    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        var request = URLRequest(url: url!)
        request.allHTTPHeaderFields = headers
        switch self {
        case .getSearchImage:
            request.httpMethod = "GET"
            return request
        case .getRandomImage:
            request.httpMethod = "GET"
            print(request.url)
            return request
        }
    }
}
