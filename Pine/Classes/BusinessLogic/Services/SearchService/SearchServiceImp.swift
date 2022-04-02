//
//  SearchServiceImp.swift
//  Pine
//
//  Created by Nikita Gavrikov on 02.04.2022.
//

import Foundation

final class SearchServiceImp: SearchService {

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

    func createDataBaseForRecentSearches() {
        let recentSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String]
        if recentSearches == nil {
            let array: [String] = []
            UserDefaults.standard.set(array, forKey: "recentSearches")
        }
    }

    func addQueryToRecent(query: String) {
        guard var recentSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String] else { return }
        if recentSearches.contains(query) {
            guard let index = recentSearches.firstIndex(of: query) else { return }
            recentSearches.remove(at: index)
        }
        recentSearches.append(query)
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }

    func clearRecentSearches() {
        guard var recentSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String] else { return }
        recentSearches.removeAll()
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }
}
