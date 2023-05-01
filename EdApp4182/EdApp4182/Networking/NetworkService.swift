//
//  NetworkService.swift
//  EdApp4182
//
//  Created by NikoS on 07.07.2022.
//

import Foundation
import UIKit

protocol Network {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    func performRequest(requestURL: String, completionHandeler: @escaping Handler)
}

extension URLSession: Network {
    typealias Handler = Network.Handler
    
    func performRequest(requestURL: String, completionHandeler: @escaping Handler) {
        guard let url = URL(string: requestURL) else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: completionHandeler)
        task.resume()
    }
}

extension Data {
    
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
    }
}

class NetworkService {
    
    private let network: Network
    
    init(network: Network = URLSession.shared) {
        self.network = network
    }
    func fetch<T: Decodable>(currentURL: String, model: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        network.performRequest(requestURL: currentURL) { (data, response, error) in
            if let error = error {
                return completionHandler(.failure(error))
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completionHandler(.success(decodedData))
            } catch let error {
                return completionHandler(.failure(error))
            }
        }
    }
    
    func fetchCharacter(byID id: Int, completion: @escaping (Result<APICharactersDTO, Error>) -> Void) {
        let url = "\(AppConstants.scheme)characters/\(id)?ts=\(AppConstants.ts)&apikey=\(AppConstants.publicKey)&hash=\(AppConstants.hash)"
        fetch(currentURL: url, model: APICharactersDTO.self, completionHandler: completion)
    }
    
    func fetchComic(byID id: Int, completion: @escaping (Result<APIComicsDTO, Error>) -> Void) {
        let url = "\(AppConstants.scheme)comics/\(id)?ts=\(AppConstants.ts)&apikey=\(AppConstants.publicKey)&hash=\(AppConstants.hash)"
        fetch(currentURL: url, model: APIComicsDTO.self, completionHandler: completion)
    }
    
    func makeTestFetch(completion: @escaping (Bool) -> Void) {
        let url = "\(AppConstants.scheme)comics/\(AppConstants.testComicsID)?ts=\(AppConstants.ts)&apikey=\(AppConstants.publicKey)&hash=\(AppConstants.hash)"
        fetch(currentURL: url, model: APIComicsDTO.self) { result in
            switch result {
            case .failure(_):
                completion(false)
                
            case .success(_):
                completion(true)
                return
            }
        }
    }
    
}
