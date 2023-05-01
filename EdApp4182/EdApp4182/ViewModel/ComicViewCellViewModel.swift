//
//  TableViewCellViewModel.swift
//  EdApp4182
//
//  Created by NikoS on 02.09.2022.
//

import UIKit
import CoreData

struct ComicViewCellViewModel {
    let title: String
    let imageURL: URL?
    
    init(with model: NSFetchedResultsController<ComicCoreDataModel>, indexPath: IndexPath){
        let comic = model.object(at: indexPath)
        if let comicName = comic.title {
            title = comicName
        } else {
            title = "No info about this comic"
        }
        if let url = comic.imageUrl {
            imageURL = URL(string: url)
        } else {
            imageURL = nil
        }
    }
}
    
    
    
