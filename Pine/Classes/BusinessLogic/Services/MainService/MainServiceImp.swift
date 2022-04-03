//
//  MainServicesImp.swift
//  Pine
//
//  Created by Nikita Gavrikov on 13.03.2022.
//

import UIKit

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

    func fetchImage(urlImage: String, completion: @escaping (UIImage) -> Void) {
        NetworkDataFetch.shared.fetchImage(urlImage: urlImage) { image in
            completion(image)
        }
    }
}
