//
//  ResultModel.swift
//  EdApp4182
//
//  Created by NikoS on 06.07.2022.
//

import Foundation

struct APICharactersDTO: Codable {
    var data: CharacterData
}

struct CharacterData: Codable {
    var results: [Character]
}

struct Character: Codable {
    var id: Int
    var name: String
    var thumbnail: ImageDTO?
}

struct CharacterImage: Codable {
    var path: String
    var `extension`: String
}
