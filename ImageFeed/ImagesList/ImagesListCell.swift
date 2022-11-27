//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Albert on 27.11.2022.
//

import UIKit

class ImagesListCell: UITableViewCell {

    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favoriteButton.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
