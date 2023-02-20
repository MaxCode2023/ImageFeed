//
//  ViewController.swift
//  ImageFeed
//
//  Created by macOS on 26.11.2022.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    @IBOutlet private weak var tableViewImage: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImageListService()
    private var photos: [Photo] = []
    private var imageListServiceObserver: NSObjectProtocol?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesListService.fetchPhotosNextPage()
        photos = imagesListService.photos
        
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImageListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            if let viewController = segue.destination as? SingleImageViewController {
                if let indexPath = sender as? IndexPath {
                    let urlImage = URL(string: photos[indexPath.row].fullImageURL)
                    viewController.urlImage = urlImage
                }
            }
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableViewImage.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableViewImage.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imagesListCell.delegate = self
        configCell(for: imagesListCell, with: indexPath)
        
        return imagesListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count-1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        cell.imageCell.image = UIImage(named: "plug")
        
        let gradientImage = CAGradientLayer()
        cell.imageCell.layer.addSublayer(gradientImage)

        gradientImage.frame = CGRect(origin: .zero, size: CGSize(width: cell.imageCell.frame.width, height: cell.imageCell.frame.height))
        gradientImage.locations = [0, 0.1, 0.3]
        gradientImage.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradientImage.startPoint = CGPoint(x: 0, y: 0.5)
        gradientImage.endPoint = CGPoint(x: 1, y: 0.5)
        gradientImage.cornerRadius = 16
        gradientImage.masksToBounds = true

        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradientImage.add(gradientChangeAnimation, forKey: "imageSkeleton")
        
        cell.imageCell.kf.indicatorType = .activity
        let urlImage = URL(string: photos[indexPath.row].thumbImageURL)
        
        cell.imageCell.kf.setImage(with: urlImage, options: [.cacheSerializer(FormatIndicatedCacheSerializer.png)]) { _ in
            gradientImage.removeFromSuperlayer()
            self.tableViewImage.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.date.text = dateFormatter.string(from: photos[indexPath.row].createdAt ?? Date())
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableViewImage.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
                
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: !photo.isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
                self.showAlert()
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Упс, что-то пошло не так(",
                                      message: "Не удалось лайкнуть картинку",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
}
