//
//  ImagePreviewViewController.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/19/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    
    var images: [UIImage] = []
    var imageViews: [UIImageView] = []
    var selectedImageIndex: Int!
    
    @IBOutlet weak var galleryScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            galleryScrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame.size = galleryScrollView.frame.size
            imageView.frame.origin.x = galleryScrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        
        let contentWidth = galleryScrollView.frame.width * CGFloat(imageViews.count)
        galleryScrollView.contentSize = CGSize(width: contentWidth, height: galleryScrollView.frame.height)
        scrollToPage(page: selectedImageIndex, animated: false)

    }
    
    private func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = galleryScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        galleryScrollView.scrollRectToVisible(frame, animated: animated)
    }
}
