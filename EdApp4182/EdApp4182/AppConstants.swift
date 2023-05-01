//
//  Credentials.swift
//  EdApp4182
//
//  Created by NikoS on 06.07.2022.
//

import Foundation
import CryptoKit

struct AppConstants {
    
    //MARK: Decoding data
    static func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map {
            String(format: "%02hhx", $0)
        }
        .joined()
    }
    
    static let hash = MD5(data: "\(AppConstants.ts)\(AppConstants.privateKey)\(AppConstants.publicKey)")
    static let scheme = "https://gateway.marvel.com:443/v1/public/"
    static let publicKey = "46202f8c443128145ec8f30f5196cb0a"
//    static let publicKey = "ef0ba99c07a114df659bd71dca1a80c9"
    static let privateKey = "e1066791614ba7329ef87ceed8d4ef083572ef2c"
//    static let privateKey = "e88aa37b243552de28d40e94d6556aacdd2ffb3a"
    static let charactersUrl = "\(scheme)characters?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)&limit={limit}&offset={offset}"
    static let characterByIdUrl = "\(scheme)characters/{characterId}/comics?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)&limit={limit}&offset={offset}"
    static let ts = String(Date().timeIntervalSince1970)
    static let dataModel = "CoreData"
    static let testComicsID = "82965"
    static let noInternetConnectionTitle = "No Internet Connection"
    static let noDataMessage = "Please turn on Internet to load data"
    static let serverUnavailableTitle = "No connection with server"
    static let backendErrorDataMessage = "You can check already uploaded data and load more later"
    
}
