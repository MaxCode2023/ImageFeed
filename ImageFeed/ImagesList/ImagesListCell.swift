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
    weak var delegate: ImagesListCellDelegate?
    
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

    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(isLiked: Bool) {
        let imageLike = isLiked == true ? UIImage(named: "liked") : UIImage(named: "no liked")
        favoriteButton.setImage(imageLike, for: .normal)
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
