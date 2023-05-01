//
//  customTableViewCell.swift
//  EdApp4182
//
//  Created by NikoS on 06.07.2022.
//

import UIKit

class ComicTableViewCell: UITableViewCell {
    @IBOutlet weak var tableViewImage: UIImageView!
    @IBOutlet weak var tableViewLabel: UILabel!
    private let imageProvider = ImageProvider()

    override func prepareForReuse() {
        super .prepareForReuse()
        //Empty imageView before reuse
        tableViewImage.image = nil
    }
    
    func setupCell(with viewModel: ComicViewCellViewModel) {
        tableViewLabel.text = viewModel.title
        guard let imageURL = viewModel.imageURL else { return }
        tableViewImage.loadImage(imageDownloader: imageProvider, url: imageURL, updatedDate: Date())
    }
    
}
