//
//  ComicCoreDataModel+Routine.swift
//  EdApp4182
//
//  Created by NikoS on 18.08.2022.
//

import Foundation
import CoreData

extension ComicCoreDataModel {
    convenience init?(context: NSManagedObjectContext, id: Int32, imageUrl: String?, title: String?, updatedDate: Date?) {
        guard let comicEntity = NSEntityDescription.entity(forEntityName: "ComicCoreDataModel", in: context) else {
            return nil
        }
    self.init(entity: comicEntity, insertInto: context)
        self.id = id
        self.imageUrl = imageUrl
        self.title = title
        self.updatedDate = updatedDate
    }
    
    @nonobjc public class func fetchRequest(character: CharacterCoreDataModel) -> NSFetchRequest<ComicCoreDataModel> {
        let request = NSFetchRequest<ComicCoreDataModel>(entityName: "ComicCoreDataModel")
        request.predicate = NSPredicate(format: "ANY characters.id == %d", character.id)
        return request
    }
    
    @nonobjc public class func fetchRequest(comic: Int) -> NSFetchRequest<ComicCoreDataModel> {
        let request = NSFetchRequest<ComicCoreDataModel>(entityName: "ComicCoreDataModel")
        request.predicate = NSPredicate(format: "id == %d", comic)
        return request
    }
    
    @nonobjc public class func fetchRequest(timeLimit: TimeInterval) -> NSFetchRequest<ComicCoreDataModel> {
        let minValidDate = Date.now.addingTimeInterval(timeLimit * (-1))
        let request = NSFetchRequest<ComicCoreDataModel>(entityName: "ComicCoreDataModel")
        request.predicate = NSPredicate(format: "updatedDate <= %@", minValidDate as NSDate)
        return request
    }
    
    func setupFrom(comics: Comics) {
        self.imageUrl = comics.thumbnail?.url
        self.title = comics.title
        print("Comic was updated")
    }
    
    private func coreDataObject(for apiComic: Comics, context: NSManagedObjectContext) -> ComicCoreDataModel? {
        var imgUrl: String?
        if let thumbnail = apiComic.thumbnail {
            imgUrl = thumbnail.path + "." + thumbnail.extension
        }
        return ComicCoreDataModel(context: context, id: Int32(apiComic.id), imageUrl: imgUrl, title: apiComic.title, updatedDate: Date())
    }
    
    func storeObject(for apiСomic: Comics, context: NSManagedObjectContext) {
        let existObject = try? context.fetch(ComicCoreDataModel.fetchRequest(comic: apiСomic.id)).first
        //Update previous version based on api result
        existObject?.setupFrom(comics: apiСomic)
        //create new one
        guard let coreDataComic = existObject ?? coreDataObject(for: apiСomic, context: context) else { return }
                
        //TODO: setupFrom
        apiСomic.charactersIds.forEach { characterId in
            let characters = (try? context.fetch(CharacterCoreDataModel.fetchRequest(id: characterId)))
            guard let character = characters?.first else { return } //first
            let updatedComics = character.comic?.mutableCopy() as? NSMutableSet
            updatedComics?.add(coreDataComic)
            character.comic = updatedComics
        }
        //MARK: end
    }
    
}
