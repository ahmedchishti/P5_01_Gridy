//
//  Creation.swift
//  Gridy
//
//  Created by Ahmed Chishti on 4/29/21.
//

import Foundation
import UIKit

class Creation {
    var image: UIImage
    static var defaultImage: UIImage {
        return UIImage.init(named:"Lake")!
    }
    init() {
        image = Creation.defaultImage
    }
    func reset () {
        image = Creation.defaultImage
    }
    // This returns an array of the default images from assets
    func collectRandomImageSet() -> [UIImage] {
        var randomImages = [UIImage]()
        let imageNames = ["Lake", "Lava", "Mountain", "Space", "Tree"]
        for i in 0 ..< imageNames.count {
            randomImages.append(UIImage.init(named: imageNames[i])!)
        }
        return randomImages
    }
}
