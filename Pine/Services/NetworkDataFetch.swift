//
//  NetworkDataFetch.swift
//  Pine
//
//  Created by Nikita Gavrikov on 27.02.2022.
//

import Foundation
import UIKit

class NetworkDataFetch {
    static let shared = NetworkDataFetch()

    private init() {}

    func fetchSearchData(query: String, page: Int, response: @escaping (SearchResult?, Error?) -> Void) {
        NetworkRequest.shared.requestData(
            request: NetworkType.getSearchImage(query: query, page: page).request
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    response(searchResult, nil)
                } catch let jsonError {
                    print("Failed decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error fetch data: \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }

    func fetchRandomData(page: Int, response: @escaping ([ImageData]?, Error?) -> Void) {
        NetworkRequest.shared.requestData(
            request: NetworkType.getRandomImage(page: page).request
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let randomImageResult = try JSONDecoder().decode([ImageData].self, from: data)
                    response(randomImageResult, nil)
                } catch let jsonError {
                    print("Failed decode JSON", jsonError.localizedDescription)
                }
            case .failure(let error):
                print("Error fetch data: \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }

    func fetchImage(urlImage: String, completion: @escaping (UIImage) -> Void ) {
        guard let url = URL(string: urlImage) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        task.resume()
    }
}
