//
//  CacheManager.swift
//  EdApp4182
//
//  Created by NikoS on 24.08.2022.
//

import Foundation
import UIKit

class CacheManager {
    
    static let shared: CacheManager = CacheManager()
    
    private let cacheAppName = "com.dashdevs.EdApp4182"
    private let cacheDirectoryName = "fsCachedData"
    private let context = CoreDataStack.shared.createContext()
    
    private func path(for id: UUID) -> String {
        return getUrl(for: id).path
    }
    
    private func getUrl(for id: UUID) -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = paths[0]
        let imagesDirectory = cacheDirectory.appendingPathComponent(cacheAppName, isDirectory: true)
            .appendingPathComponent(cacheDirectoryName, isDirectory: true)
            .appendingPathComponent(id.uuidString, isDirectory: false)
        return imagesDirectory
    }
    
    func setImage(for url: String, sourcePath: String, updatedDate: Date) -> String {
        let fileID = UUID()
        //use path
        let path = path(for: fileID)
        //copy source on this path
        if FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.removeItem(at: URL.init(fileURLWithPath: path))
        }
        do {
            try FileManager.default.copyItem(
                at: URL.init(fileURLWithPath: sourcePath),
                to: URL.init(fileURLWithPath: path)
            )
        } catch {
            print(error)
        }
        _ = ImageCache(context: context, fileID: fileID, url: url, updatedDate: updatedDate)
        //save in DB (URL - path) (NSObject)
        CoreDataStack.shared.save(with: context)
        return path
    }
    
    func getImage(for url: String) -> URL? {
        //context ask fetch(conv)
        let cache = try? context.fetch(ImageCache.fetchRequest(url: url))
        //return path or nil
        guard let fileID = cache?.first?.fileID else { return nil }
        return getUrl(for: fileID)
    }
    
    func removeOldImages(for timeLimit: TimeInterval) {
        //fetch images by set time limit
        let caches = try? context.fetch(ImageCache.fetchRequest(timeLimit: timeLimit))
        //action with each one
        caches?.forEach({ cache in
            if let id = cache.fileID {
                //remove from disk
                try? FileManager.default.removeItem(at: getUrl(for: id))
            }
            //delete context
            context.delete(cache)
        })
        //save context after all changes
        CoreDataStack.shared.save(with: context)
    }
}
