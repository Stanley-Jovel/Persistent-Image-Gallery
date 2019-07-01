//
//  ZoomedImageViewController.swift
//  Image Gallery
//
//  Created by Luis Stanley Jovel on 5/3/19.
//  Copyright © 2019 stanley jovel. All rights reserved.
//

import UIKit

class ZoomedImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageView = ImageView()
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var backgroundImage: UIImage? {
        get {
            return imageView.backgroundImage
        }
        set {
            scrollView?.zoomScale = 1.0
            imageView.backgroundImage = newValue
            let size = newValue?.size ?? CGSize.zero
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            scrollViewWidth?.constant = size.width
            scrollViewHeight?.constant = size.height
            if size.width > 0, size.height > 0 {
                scrollView?.zoomScale = max(imageView.bounds.size.width / size.width, imageView.bounds.size.height / size.height)
            }
        }
    }
}

extension ZoomedImageViewController {
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidth.constant = scrollView.contentSize.width
        scrollViewHeight.constant = scrollView.contentSize.height
    }
}
