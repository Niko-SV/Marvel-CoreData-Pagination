//
//  ImageCache+CoreDataProperties.swift
//  EdApp4182
//
//  Created by NikoS on 24.08.2022.
//
//

import Foundation
import CoreData


extension ImageCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCache> {
        return NSFetchRequest<ImageCache>(entityName: "ImageCache")
    }

    @NSManaged public var url: String?
    @NSManaged public var fileID: UUID?
    @NSManaged public var updatedDate: Date?

}

extension ImageCache : Identifiable {}
