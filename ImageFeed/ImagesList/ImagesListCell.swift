//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Albert on 27.11.2022.
//

import UIKit
import Kingfisher

class ImagesListCell: UITableViewCell {

    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.setTitle("", for: .normal)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
            
        imageCell.kf.cancelDownloadTask()
    }

}
