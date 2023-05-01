//
//  CharacterCoreDataModel+Init.swift
//  EdApp4182
//
//  Created by NikoS on 17.08.2022.
//

import Foundation
import CoreData

extension CharacterCoreDataModel {
    convenience init?(context: NSManagedObjectContext, id: Int, imageUrl: String?, name: String?, updatedDate: Date?) {
        guard let comicEntity = NSEntityDescription.entity(forEntityName: "CharacterCoreDataModel", in: context) else {
            return nil
        }
    self.init(entity: comicEntity, insertInto: context)
        self.id = Int32(id)
        self.imageUrl = imageUrl
        self.name = name
        self.loadingState = CharacterLoadingState(context: context)
        self.updatedDate = updatedDate
    }
    
    @nonobjc public class func fetchRequest(id: Int) -> NSFetchRequest<CharacterCoreDataModel> {
        let request = NSFetchRequest<CharacterCoreDataModel>(entityName: "CharacterCoreDataModel")
        request.predicate = NSPredicate(format: "id == %d", id)
        return request
    }
    
    @nonobjc public class func fetchRequest(timeLimit: TimeInterval) -> NSFetchRequest<CharacterCoreDataModel> {
        let minValidDate = Date.now.addingTimeInterval(timeLimit * (-1))
        let request = NSFetchRequest<CharacterCoreDataModel>(entityName: "CharacterCoreDataModel")
        request.predicate = NSPredicate(format: "updatedDate <= %@", minValidDate as NSDate)
        return request
    }
    
    func setupFrom(character: Character) {
        self.imageUrl = character.thumbnail?.url
        self.name = character.name
        print("Character was updated")
    }
    
    private class func coreDataObject(for apiСharacter: Character, context: NSManagedObjectContext) -> CharacterCoreDataModel? {
        var imgUrl: String?
        if let thumbnail = apiСharacter.thumbnail {
            imgUrl = thumbnail.path + "." + thumbnail.extension
        }
        return CharacterCoreDataModel(context: context, id: apiСharacter.id, imageUrl: imgUrl, name: apiСharacter.name, updatedDate: Date())
    }
    
    class func storeObject(_ character: Character, context: NSManagedObjectContext) {
        let existObject = try? context.fetch(CharacterCoreDataModel.fetchRequest(id: character.id)).first
        existObject?.setupFrom(character: character)
        if existObject == nil {
            _ = coreDataObject(for: character, context: context)
        }
    }
   
}
