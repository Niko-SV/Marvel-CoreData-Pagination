//
//  CleanCacheManager.swift
//  EdApp4182
//
//  Created by NikoS on 26.08.2022.
//

import Foundation
import CoreData

class UpdateManager {
    
    var checkInterval: TimeInterval = 60 * 60
    var nextCheckKey = "nextCheck"
    var timer: Timer?
    
    private var updateInterval: TimeInterval = 60 * 60 * 24
    
    private let context = CoreDataStack.shared.createContext()
    private let service = NetworkService()
    
    func startUpdating() {
        //If we started update after the planned check
        if let plannedDate = UserDefaults.standard.object(forKey: nextCheckKey) as? Date, plannedDate < Date.now {
            checkAndUpdate()
        }
        scheduleNextCheck()
    }
    
    private func scheduleNextCheck() {
        if let plannedCheckDate = UserDefaults.standard.object(forKey: nextCheckKey) as? Date {
            //if we are before the check time
            if plannedCheckDate < Date.now {
                let nextCheckDate = Date.now.addingTimeInterval(checkInterval)
                UserDefaults.standard.set(nextCheckDate, forKey: nextCheckKey)
                print(nextCheckDate.timeIntervalSinceNow)
                timer = Timer.scheduledTimer(withTimeInterval: nextCheckDate.timeIntervalSinceNow, repeats: false, block: { [weak self] _ in
                    self?.scheduleNextCheck()
                    self?.checkAndUpdate()
                })
                //if we are after the check time
            } else if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: plannedCheckDate.timeIntervalSinceNow, repeats: false, block: { [weak self] _ in
                    self?.scheduleNextCheck()
                    self?.checkAndUpdate()
                })
            }
        } else {
            let nextCheckDate = Date.now.addingTimeInterval(checkInterval)
            UserDefaults.standard.set(nextCheckDate, forKey: nextCheckKey)
            timer = Timer.scheduledTimer(withTimeInterval: nextCheckDate.timeIntervalSinceNow, repeats: false, block: { [weak self] _ in
                self?.scheduleNextCheck()
                self?.checkAndUpdate()
            })
        }
    }
    
    private func reloadCharacter(_ character: CharacterCoreDataModel) {
        service.fetchCharacter(byID: Int(character.id)) { result in
            switch result {
            case .success(let dto):
                guard let first = dto.data.results.first else { return }
                character.setupFrom(character: first)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func reloadComic(_ comic: ComicCoreDataModel) {
        service.fetchComic(byID: Int(comic.id)) { result in
            switch result {
            case .success(let dto):
                guard let first = dto.data.results.first else { return }
                comic.setupFrom(comics: first)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkAndUpdate() {
        //Clean images
        CacheManager.shared.removeOldImages(for: updateInterval)
        //reload data
        guard Reachability.isConnectedToNetwork() else { return }
        let characterRequest = CharacterCoreDataModel.fetchRequest(timeLimit: updateInterval)
        let comicRequest = ComicCoreDataModel.fetchRequest(timeLimit: updateInterval)
        
        if let result = try? CoreDataStack.shared.mainContext.fetch(characterRequest) {
            result.forEach { reloadCharacter($0) }
        }
        if let result = try? CoreDataStack.shared.mainContext.fetch(comicRequest) {
            result.forEach { reloadComic($0) }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
}
