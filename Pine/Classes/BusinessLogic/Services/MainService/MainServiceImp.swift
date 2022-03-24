//
//  MainServicesImp.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.03.2022.
//

import Foundation

final class MainServiceImp: MainService {

    func fetchRandomData(page: Int, completion: @escaping ([ImageData]?, Error?) -> Void) {
        NetworkDataFetch.shared.fetchRandomData(page: page) { result, error in
            if let error = error {
                print(error.localizedDescription, "Ошибка рандом")
                completion(nil, error)
            }
            guard let result = result else { return }
            completion(result, nil)
        }
    }

    func fetchSearchData(query: String, page: Int, completion: @escaping (SearchResult?, Error?) -> Void) {
        NetworkDataFetch.shared.fetchSearchData(query: query, page: page) { result, error in
            if let error = error {
                print(error.localizedDescription, "Ошибка поиска")
                completion(nil, error)
            }
            guard let result = result else { return }
            completion(result, nil)
        }
    }
}
