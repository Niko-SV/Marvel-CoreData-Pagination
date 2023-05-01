//
//  Entity+CoreDataProperties.swift
//  EdApp4182
//
//  Created by NikoS on 17.08.2022.
//
//

import Foundation
import CoreData


extension CharacterLoadingState {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterLoadingState> {
        return NSFetchRequest<CharacterLoadingState>(entityName: "CharacterLoadingState")
    }
    @NSManaged public var offset: Int32
    @NSManaged public var isAllLoaded: Bool
    @NSManaged public var date: Date?
}

extension CharacterLoadingState : Identifiable {}
