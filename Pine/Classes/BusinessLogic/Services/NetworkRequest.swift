//
//  NetworkRequest.swift
//  Pine
//
//  Created by Nikita Gavrikov on 27.02.2022.
//

import Foundation

class NetworkRequest {
    static let shared = NetworkRequest()

    private var task: URLSessionDataTask?

    private init() {}

    func requestData(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        if let task = task {
            task.cancel()
        }
        task = URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        task?.resume()
    }
}
