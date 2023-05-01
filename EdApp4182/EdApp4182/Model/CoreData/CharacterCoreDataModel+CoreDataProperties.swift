//
//  CharacterCoreDataModel+CoreDataProperties.swift
//  EdApp4182
//
//  Created by NikoS on 17.08.2022.
//
//

import Foundation
import CoreData


extension CharacterCoreDataModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterCoreDataModel> {
        return NSFetchRequest<CharacterCoreDataModel>(entityName: "CharacterCoreDataModel")
    }
    @NSManaged public var id: Int32
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var comic: NSSet?
    @NSManaged public var loadingState: CharacterLoadingState?
}

extension CharacterCoreDataModel : Identifiable {}
