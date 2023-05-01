//
//  ImageDTO.swift
//  EdApp4182
//
//  Created by NikoS on 30.08.2022.
//

import Foundation

struct ImageDTO: Codable {
    var path: String
    var `extension`: String
    var url: String {
            path + "." + `extension`
    }
}
