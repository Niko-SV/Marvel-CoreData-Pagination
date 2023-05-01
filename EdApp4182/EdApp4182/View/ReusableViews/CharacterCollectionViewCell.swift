//
//  customCollectionViewCell.swift
//  EdApp4182
//
//  Created by NikoS on 06.07.2022.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionViewImage: UIImageView!
    @IBOutlet weak var collectionViewLabel: UILabel!
    private let imageProvider = ImageProvider()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //Empty imageView before reuse
        self.collectionViewImage.image = nil
    }
    override var isSelected: Bool {
        //Change color of tint if cell is selected
        didSet{
            UIView.animate(withDuration: 0.5) {
                self.collectionViewImage.layer.borderColor = self.isSelected ? UIColor.green.cgColor : UIColor.red.cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         let view = UIView(frame: contentView.bounds)
        view.isUserInteractionEnabled = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = .lightGray
        collectionViewImage.layer.cornerRadius = collectionViewImage.frame.height / 2
        collectionViewImage.layer.borderWidth = 5
        collectionViewImage.layer.borderColor = UIColor.red.cgColor
    }
    
    func setupCell(with viewModel: CharacterViewCellViewModel) {
        collectionViewLabel.text = viewModel.name
        guard let imageURL = viewModel.imageURL else { return }
        collectionViewImage.loadImage(imageDownloader: imageProvider, url: imageURL, updatedDate: Date())
    }
}
