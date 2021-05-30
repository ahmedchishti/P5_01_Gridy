//
//  Drag&Drop Extension.swift
//  Gridy
//
//  Created by Ahmed Chishti on 5/6/21.
//

import Foundation
import UIKit

// MARK: Extensions for the CollectionView drop and drag delegates


extension PuzzleViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIDropInteractionDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if collectionView == boardCollectionView {
            return true
        } else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        selectedIndexPath = indexPath
        let image = piecesCVImages[indexPath.item]
        
        // Only allow the image to be moved if it isn't a placeholder image
        
        if image != UIImage.init(named: placeholderImages.blank.rawValue) && image != UIImage.init(named: placeholderImages.lookup.rawValue) {
            let itemProvider = NSItemProvider(object: image as UIImage)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = image
            return [dragItem]
        }
        return []
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith
                            coordinator: UICollectionViewDropCoordinator) {
        if let indexPath = coordinator.destinationIndexPath {
            if indexPath.row >= correctOrderImages.count {
                return
                
            } else if collectionView == boardCollectionView {
                moveItems(coordinator: coordinator, destinationIndexPath: coordinator.destinationIndexPath!, collectionView: collectionView)
            }
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if destinationIndexPath!.row >= correctOrderImages.count {
            return UICollectionViewDropProposal(operation: .forbidden)
        } else if collectionView == boardCollectionView {
            return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    private func moveItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        totalMoves += 1
        let items = coordinator.items
        collectionView.performBatchUpdates({
            let dragItem = items.first!.dragItem.localObject as! UIImage
            
            // For correct move
            
            if dragItem == correctOrderImages[destinationIndexPath.item]{
                correctMoves += 1
                consecutiveCorrectMoves += 1
                consecutiveIncorrectMoves = 0
                self.boardCVImages.insert(dragItem, at: destinationIndexPath.row)
                boardCollectionView.insertItems(at: [destinationIndexPath])
                piecesCVImages.remove(at: selectedIndexPath.row)
                piecesCVImages.insert(UIImage.init(named: "blank")!, at: selectedIndexPath.row)
                piecesCollectionView.reloadData()
            } else {
                
                consecutiveIncorrectMoves += 1
                consecutiveCorrectMoves = 0
            }
            
        })
        collectionView.performBatchUpdates({
            let dragItem = items.first!.dragItem.localObject as! UIImage
            if dragItem == correctOrderImages[destinationIndexPath.item] {
                self.boardCVImages.remove(at: destinationIndexPath.row + 1)
                let nextIndexPath = IndexPath(row: destinationIndexPath.row + 1, section: 0)
                boardCollectionView.deleteItems(at: [nextIndexPath])
                
            }
            
        })
        coordinator.drop(items.first!.dragItem, toItemAt: destinationIndexPath)
        updateScore()
        if correctMoves == boardCVImages.count {
            endGame()
        }
    }
}

