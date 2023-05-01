//
//  ErrorLoadingTextView.swift
//  EdApp4182
//
//  Created by NikoS on 19.08.2022.
//

import UIKit

class MessageLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        textColor = .red
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        textAlignment = .center
    }
}
