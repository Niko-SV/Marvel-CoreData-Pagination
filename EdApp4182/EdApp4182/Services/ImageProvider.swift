//
//  ImageDownloader.swift
//  EdApp4182
//
//  Created by NikoS on 23.08.2022.
//

import Foundation

class ImageProvider {
        
    func download(url: URL, updatedDate: Date, completion: @escaping (Error?, String?) -> Void) {
        //Download the remote URL
        let task = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            //Early exit on error
            guard let tempURL = tempURL else {
                completion(error, nil)
                return
            }
            let cachePath = CacheManager.shared.setImage(for: url.absoluteString, sourcePath: tempURL.path, updatedDate: updatedDate)
            completion(nil, cachePath)
        }
        task.resume()
    }
    
    func loadData(url: URL, updatedDate: Date, completion: @escaping (Error?, Data?) -> Void) {
    
        //MARK: cacheManager.getImage
        let cachePath = CacheManager.shared.getImage(for: url.absoluteString)
        if let cachePath = cachePath {
            //If the image exists in cache, load the image from the cache and exit
            if let data = try? Data(contentsOf: cachePath) {
                completion(nil, data)
                return
            }
        }
        //If the image doesn't exist in the cache, download the image to the cache
        download(url: url, updatedDate: updatedDate) { error, filePath in
            guard let filePath = filePath else {
                completion(error, nil)
                return
            }
            let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            completion(nil, data)
        }
    }
}
