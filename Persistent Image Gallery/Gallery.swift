//
//  Gallery.swift
//  Image Gallery
//
//  Created by Luis Stanley Jovel on 5/12/19.
//  Copyright © 2019 stanley jovel. All rights reserved.
//

import Foundation
import UIKit

struct Gallery: Codable {
  var name: String
  var images: [URL]
  
  var json: Data? {
    return try? JSONEncoder().encode(self)
  }

  init(_ name: String) {
    self.name = name
    images = [URL]()
  }
  
  init?(json: Data) {
    if let newValue = try? JSONDecoder().decode(Gallery.self, from: json) {
      self = newValue
    } else {
      return nil
    }
  }
}
