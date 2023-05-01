//
//  Pagination.swift
//  EdApp4182
//
//  Created by NikoS on 10.08.2022.
//

import Foundation
import UIKit

class CharactersPagination {
    
    var isFetchingCharacters = false
    var allDataLoaded = false
    var limit = 10
    
    private let service = NetworkService()
    private let context = CoreDataStack.shared.createContext()
    
    //MARK: Data fetch
    func fetchCharactersData(completion: ((Error?) -> Void)?) {
        guard !isFetchingCharacters else { return }
        guard !allDataLoaded else {
            completion?(nil)
            return
        }
        let characters = (try? context.fetch(CharacterCoreDataModel.fetchRequest())) ?? []
        service.fetch(currentURL: AppConstants.charactersUrl
            .replacingOccurrences(of: "{limit}", with: String(limit))
            .replacingOccurrences(of: "{offset}", with: String(characters.count)),
                      model: APICharactersDTO.self) { [weak self] result in
            switch result {
            case let .success(value):
                self?.handleSuccessForCharacters(newCharacters: value.data.results, completion: completion)
            case let .failure(error):
                self?.isFetchingCharacters = false
                completion?(error)
            }
        }
    }
    
    //MARK: Handling success result
    @inline(__always) private func handleSuccessForCharacters(
        newCharacters: [Character],
        completion: ((Error?) -> Void)?)
    {
        newCharacters.forEach { character in
            CharacterCoreDataModel.storeObject(character, context: context)
        }
        CoreDataStack.shared.save(with: context) { [weak self] error, _ in
            self?.isFetchingCharacters = false
            self?.allDataLoaded = newCharacters.count < self?.limit ?? 0
            completion?(error)
        }
    }
}
