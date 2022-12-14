//
//  ViewController.swift
//  ImageFeed
//
//  Created by macOS on 26.11.2022.
//

import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet private var tableViewImage: UITableView!
    
    private var photosName = [String]()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosName = Array(0..<20).map{"\($0)"}
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imagesListCell, with: indexPath)
        
        return imagesListCell
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        cell.imageCell.image = image
        cell.date.text = dateFormatter.string(from: Date())
        
        if indexPath.row % 2 == 0 {
            cell.favoriteButton.setImage(UIImage(named: "Active"), for: .normal)
        } else{
            cell.favoriteButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
    }
}

