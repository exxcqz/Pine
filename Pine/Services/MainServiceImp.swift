//
//  MainServicesImp.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.03.2022.
//

import Foundation

final class MainServiceImp: MainService {

    func fetchRandomData(page: Int, completion: @escaping ([ImageData]) -> Void) {
        NetworkDataFetch.shared.fetchRandomData(page: page) { result, error in
            if let error = error {
                print(error.localizedDescription, "Ошибка рандом")
            }
            guard let result = result else { return }
            completion(result)
        }
    }

    func fetchSearchData(query: String, page: Int, completion: @escaping (SearchResult) -> Void) {
        NetworkDataFetch.shared.fetchSearchData(query: query, page: page) { result, error in
            if let error = error {
                print(error.localizedDescription, "Ошибка поиска")
            }
            guard let result = result else { return }
            completion(result)
        }
    }
}
