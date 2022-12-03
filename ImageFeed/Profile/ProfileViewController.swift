//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Albert on 03.12.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exitButton.setTitle("", for: .normal)
    }

    @IBAction func clickExitButton(_ sender: Any) {
        
    }
}
