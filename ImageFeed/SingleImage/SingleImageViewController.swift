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
    @IBOutlet weak private var scrollView: UIScrollView!

    @IBOutlet weak var sharingButton: UIButton!
    
    var urlImage: URL?
    
//    var image: UIImage! {
//        didSet {
//            guard isViewLoaded else { return } // 1
//            imageView.image = image // 2
//            rescaleAndCenterImageInScrollView(image: image)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        sharingButton.setTitle("", for: .normal)
        
        guard let urlImage = urlImage else { return }
        imageView.kf.setImage(with: urlImage)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // rescaleAndCenterImageInScrollView(image: imageView.image!)
    }
    
    @IBAction private func clickBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    @IBAction private func clickSharingButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [imageView.image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
