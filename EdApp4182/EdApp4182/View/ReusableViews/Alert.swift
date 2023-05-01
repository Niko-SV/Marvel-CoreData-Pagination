//
//  Akert.swift
//  EdApp4182
//
//  Created by NikoS on 05.09.2022.
//

import UIKit

class Alert {
    func showFirstOfflineLoadAlert(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
