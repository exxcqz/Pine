//
//  SearchService.swift
//  Pine
//
//  Created by Nikita Gavrikov on 02.04.2022.
//

import Foundation

protocol HasSearchService {
    var searchService: SearchService { get }
}

protocol SearchService {
    func fetchSearchData(query: String, page: Int, completion: @escaping (SearchResult?, Error?) -> Void)
    func createDataBaseForRecentSearches()
    func addQueryToRecent(query: String)
    func clearRecentSearches()
}
