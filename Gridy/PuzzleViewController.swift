//
//  PuzzleViewController.swift
//  Gridy
//
//  Created by Ahmed Chishti on 5/7/21.
//

import Foundation
import UIKit

class PuzzleViewController: UIViewController {
    
    // MARK: Global Variables
    
    var creation = Creation.init()
    var piecesCVImages = [UIImage]()
    var correctOrderImages = [UIImage]()
    var boardCVImages = [UIImage]()
    var columns = Int()
    var selectedIndexPath = IndexPath()
    var totalMoves: Int = 0
    var correctMoves: Int = 0
    var consecutiveCorrectMoves: Int = 0
    var consecutiveIncorrectMoves: Int = 0
    
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var lookupImageView: UIImageView!
    @IBOutlet weak var piecesCollectionView: UICollectionView!
    @IBOutlet weak var boardCollectionView: UICollectionView!
    @IBOutlet weak var piecesCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var boardCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    enum placeholderImages: String {
        case blank = "blank"
        case lookup = "Gridy-lookup"
    }
    
    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        NotificationCenter.default.addObserver(self, selector: #selector(PuzzleViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    @objc func rotated() {
        let cells = boardCollectionView.visibleCells
        for cell in cells {
             do {
                try <#throwing expression#>
            } catch <#pattern#> {
                <#statements#>
            }
        }
    }
    
    func config() {
        
        
        // Set delegates for Puzzle View Controller
        
        configureDelegates(collectionView: piecesCollectionView)
        configureDelegates(collectionView: boardCollectionView)
        
        // Additional Setup
        
        correctOrderImages = piecesCVImages
        piecesCVImages = piecesCVImages.shuffled()
        lookupImageView.image = creation.image
        lookupImageView.isHidden = true
        addPlaceHolderImages()
    }
    
    func configureDelegates(collectionView: UICollectionView){
        
        // Set delegates for all collection views
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        boardCollectionView.reloadData()
        for cell in boardCollectionView.visibleCells {
            print(cell)
        }
            
       print("oky")
        
        
//        let indexPath = IndexPath(item: 1, section: 1)
//        if let cell = boardCollectionView.cellForItem(at: indexPath) as? PuzzleCollectionViewCell {
//
//            if let myImageView = cell.imageView {
//
//                myImageView.frame.size = cell.frame.size
//
//            } else {
//                print("error")
//            }
//
//        }
        
    }
    
    //      piecesCollectionView.reloadData()
    
    //
    //        let cell = boardCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PuzzleCollectionViewCell
    //
    
    
    
    func addPlaceHolderImages() {
        
        // Add blank placeholder images
        
        if piecesCVImages.count == 25 {
            columns = 7
            piecesCVImages.append(UIImage.init(named: placeholderImages.blank.rawValue)!)
            piecesCVImages.append(UIImage.init(named: placeholderImages.blank.rawValue)!)
        } else if piecesCVImages.count == 16 {
            columns = 6
            piecesCVImages.append(UIImage.init(named: placeholderImages.blank.rawValue)!)
        } else if piecesCVImages.count == 9{
            columns = 5
        }
        for _ in 0 ..< correctOrderImages.count {
            boardCVImages.append(UIImage.init(named: placeholderImages.blank.rawValue)!)
        }
        
        // Insert lookup image for puzzle pieces
        
        let eye = UIImage.init(named: placeholderImages.lookup.rawValue)!
        piecesCVImages.append(eye)
        
        piecesCollectionView.reloadData()
        boardCollectionView.reloadData()
    }
    
    // MARK: Scoring
    
    func updateScore() {
        
        // Display the change in score
        
        movesLabel.text = String(totalMoves)
        
    }
    
    // MARK: Gameover
    
    func endGame() {
        present(AlertController.init().endGameAlertController(self, totalMoves: totalMoves), animated: true)
    }
    
    func displaySharingOptions(){
        present(AlertController.init().shareViewController(self, image: creation.image, totalMoves: totalMoves), animated: true, completion: nil)
    }
}


