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
                print(error.localizedDescription)
            }
            guard let result = result else { return }
            completion(result)
        }
    }
}
