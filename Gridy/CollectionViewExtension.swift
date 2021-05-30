//
//  CollectionViewExtension.swift
//  Gridy
//
//  Created by Ahmed Chishti on 5/6/21.
//

import Foundation
import UIKit

// MARK: Extension for CollectionView delegates

extension PuzzleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.piecesCollectionView ? piecesCVImages.count : boardCVImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PuzzleCollectionViewCell
        cell.layer.borderColor = UIColor.init(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
        cell.layer.borderWidth = 1
        cell.layer.backgroundColor = UIColor.white.cgColor
        
        cell.imageView.contentMode = .scaleAspectFit
        
        if collectionView == piecesCollectionView {
            cell.setImage(image: piecesCVImages[indexPath.item])
        }
        if collectionView == boardCollectionView {
            if (boardCVImages[indexPath.item] as UIImage?) != nil {
                cell.setImage(image: boardCVImages[indexPath.item])
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == piecesCollectionView {
            let width = (piecesCollectionView.frame.size.width - 30) / CGFloat(columns)
            return CGSize(width: width, height: width)
        } else {
            let width = (boardCollectionView.frame.size.width) / CGFloat(Double(boardCVImages.count).squareRoot())
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == piecesCollectionView {
            return 5
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == piecesCollectionView {
            return 5
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Display the image for 2 seconds
        
        if indexPath.item == (piecesCVImages.count - 1) {
            lookupImageView.isHidden = false
            lookupImageView.layer.borderColor = UIColor(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
            lookupImageView.layer.borderWidth = 5
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.hideLookupImage), userInfo: nil, repeats: false)
        }
    }
    
    @objc func hideLookupImage() {
        lookupImageView.isHidden = true
    }
}
