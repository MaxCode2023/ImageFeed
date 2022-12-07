//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Albert on 07.12.2022.
//

import UIKit

class SingleImageViewController: UIViewController {

    
    @IBOutlet weak private var buttonBack: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return } // 1
            imageView.image = image // 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        imageView.image = image
    }
    
    @IBAction func clickBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
