//
//  CollectionViewCellViewModel.swift
//  EdApp4182
//
//  Created by NikoS on 02.09.2022.
//

import UIKit
import CoreData

struct CharacterViewCellViewModel {
    let name: String
    var imageURL: URL?
    
    init(with model: NSFetchedResultsController<CharacterCoreDataModel>, indexPath: IndexPath){
        let character = model.object(at: indexPath)
        if let characterName = character.name {
            name = characterName
        } else {
            name = "Unknown character"
        }
        if let url = character.imageUrl {
            imageURL = URL(string: url)
        }
    }
}
