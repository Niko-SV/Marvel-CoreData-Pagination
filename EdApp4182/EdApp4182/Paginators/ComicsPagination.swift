//
//  ComicsPagination.swift
//  EdApp4182
//
//  Created by NikoS on 18.08.2022.
//

import Foundation

class ComicsPagination {
    
    var isFetching = false
    
    private let context = CoreDataStack.shared.createContext()
    private let service = NetworkService()
    private let comicsLimit = 5
    
    //MARK: Fetch comics by character id
    func fetchComicsData(characterId: Int, completion: ((Error?, Bool) -> Void)? = nil) {
        guard !isFetching  else { return }
        let characters = (try? context.fetch(CharacterCoreDataModel.fetchRequest(id: characterId)))
        let character = characters?.first
        if character == nil {
            completion?(NSError(domain:"", code: 400, userInfo:nil), false)
            return
        }
        guard let loadingState = characters?.first?.loadingState else {
            completion?(NSError(domain:"", code: 400, userInfo:nil), false)
            return
        }
        guard !loadingState.isAllLoaded else {
            completion?(nil, false)
            return
        }
        isFetching = true
        service.fetch(currentURL: AppConstants.characterByIdUrl
            .replacingOccurrences(of: "{limit}", with: String(comicsLimit))
            .replacingOccurrences(of: "{offset}", with: String(loadingState.offset))
            .replacingOccurrences(of: "{characterId}", with: String(characterId)),
                      model: APIComicsDTO.self) { [weak self] result in
            switch result {
            case let .success(value):
                print("fetching \(characterId)")
                self?.context.perform {
                    self?.handleSuccessComicsFetch(
                        newComics: value.data.results,
                        loadingState: loadingState,
                        completion: completion
                    )
                }
                
            case let .failure(error):
                self?.isFetching = false
                completion?(error, false)
            }
        }
    }
    
    //MARK: Handling success result
    @inline(__always) private func handleSuccessComicsFetch(
        newComics: [Comics],
        loadingState: CharacterLoadingState,
        completion: ((Error?, Bool) -> Void)? = nil)
    {
        newComics.forEach { apiComic in
            ComicCoreDataModel().storeObject(for: apiComic, context: context)
        }
        loadingState.offset += Int32(newComics.count)
        loadingState.isAllLoaded = newComics.count < comicsLimit
        CoreDataStack.shared.save(with: context) { [weak self] error, hasChanges in
            self?.isFetching = false
            completion?(error, hasChanges)
        }
    }
}
