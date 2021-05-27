//
//  PuzzleCollectionViewCell.swift
//  Gridy
//
//  Created by Ahmed Chishti on 5/6/21.
//

import Foundation
import UIKit

public class PuzzleCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    public func setImage(image: UIImage?) {
        if let newImage = image {
            imageView.contentMode = .scaleAspectFit
            imageView.image = newImage
        }
        
    }
    
}
