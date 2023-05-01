//
//  ComicsListModel.swift
//  EdApp4182
//
//  Created by NikoS on 06.07.2022.
//

import Foundation

struct APIComicsDTO: Codable {
    var data: ComicData
}

struct ComicData: Codable {
    var results: [Comics]
}

struct Comics: Codable {
    
    struct CharacterList: Codable {
        var items: [Character]
    }
    
    struct Character: Codable {
        var resourceURI: String
    }
    
    var id: Int
    var thumbnail: ImageDTO?
    var title: String?
    var characters: CharacterList
    var charactersIds: [Int] {
        characters.items.compactMap {
            guard let id = $0.resourceURI.components(separatedBy: "/").last else { return nil }
            return Int(id)
        }
    }
}
