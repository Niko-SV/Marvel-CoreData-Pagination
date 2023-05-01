//
//  ChacracterModel.swift
//  EdApp4182
//
//  Created by NikoS on 05.07.2022.
//

import Foundation

struct Character: Codable {
    
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: Image?
    var comics: ComicsList?
    
}
