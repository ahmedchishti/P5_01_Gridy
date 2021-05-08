//
//  PuzzleCollectionViewCell.swift
//  Gridy
//
//  Created by Ahmed Chishti on 5/6/21.
//

import Foundation
import UIKit

class PuzzleCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    func setImage(image: UIImage?) {
        if let newImage = image {
            imageView.image = newImage
        }
        
    }
    
}
