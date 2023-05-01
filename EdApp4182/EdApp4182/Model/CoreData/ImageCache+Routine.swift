//
//  ImageCache+Routine.swift
//  EdApp4182
//
//  Created by NikoS on 24.08.2022.
//

import Foundation
import CoreData

extension ImageCache {
    convenience init?(context: NSManagedObjectContext, fileID: UUID, url: String, updatedDate: Date?) {
        guard let comicEntity = NSEntityDescription.entity(forEntityName: "ImageCache", in: context) else {
            return nil
        }
    self.init(entity: comicEntity, insertInto: context)
        self.fileID = fileID
        self.url = url
        self.updatedDate = updatedDate
    }
    
    @nonobjc public class func fetchRequest(url: String) -> NSFetchRequest<ImageCache> {
        let request = NSFetchRequest<ImageCache>(entityName: "ImageCache")
        request.predicate = NSPredicate(format: "url == %@", url)
        return request
    }
    
    @nonobjc public class func fetchRequest(timeLimit: TimeInterval) -> NSFetchRequest<ImageCache> {
        let minValidDate = Date.now.addingTimeInterval(timeLimit * (-1))
        let request = NSFetchRequest<ImageCache>(entityName: "ImageCache")
        request.predicate = NSPredicate(format: "updatedDate <= %@", minValidDate as NSDate)
        return request
    }
    
}


