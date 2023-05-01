//
//  ComicCoreDataModel+CoreDataProperties.swift
//  EdApp4182
//
//  Created by NikoS on 12.08.2022.
//
//

import Foundation
import CoreData
import UIKit

extension ComicCoreDataModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ComicCoreDataModel> {
        NSFetchRequest<ComicCoreDataModel>(entityName: "ComicCoreDataModel")
    }
    @NSManaged public var id: Int32
    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var characters: NSSet?
}

extension ComicCoreDataModel : Identifiable {}
