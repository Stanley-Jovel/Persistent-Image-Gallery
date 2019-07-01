//
//  ImageView.swift
//  Image Gallery
//
//  Created by Luis Stanley Jovel on 5/4/19.
//  Copyright © 2019 stanley jovel. All rights reserved.
//

import UIKit

class ImageView: UIView {
    var backgroundImage: UIImage? {
        didSet {
            // When image is set, we need to re-draw ourselves
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
}
