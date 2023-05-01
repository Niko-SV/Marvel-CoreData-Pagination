//
//  ExtensionUIImageView.swift
//  EdApp4182
//
//  Created by NikoS on 07.07.2022.
//

import UIKit

extension UIImageView {
    
    func loadImage(imageDownloader: ImageProvider, url: URL, updatedDate: Date) {
        imageDownloader.loadData(url: url, updatedDate: updatedDate) { error, data in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
