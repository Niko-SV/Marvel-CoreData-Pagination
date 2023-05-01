//
//  ExtensionUICollectionView.swift
//  EdApp4182
//
//  Created by NikoS on 11.08.2022.
//

import UIKit

extension UICollectionView {
    
    func reloadOnMain() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
