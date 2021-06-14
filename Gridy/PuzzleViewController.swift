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
    
    enum placeholderImages: String {
        case blank = "blank"
        case lookup = "Gridy-lookup"
    }
    
    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        
        let highScore = UserDefaults.standard.integer(forKey: "HighScore")
        
        let previousScore = UserDefaults.standard.integer(forKey: "PreviousScore")
        
        if previousScore > 0 {
            present(AlertController.init().scoreAlertController(previousScore: String(previousScore), highScore: String(highScore)), animated: true)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        boardCollectionView.reloadData()
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
        
        UserDefaults.standard.set(totalMoves, forKey: "PreviousScore")
        
        let previousHighScore = UserDefaults.standard.integer(forKey: "HighScore")
        
        if totalMoves < previousHighScore || previousHighScore == 0 {
            UserDefaults.standard.set(totalMoves, forKey: "HighScore")
        }
    }
    
    func displaySharingOptions(){
        present(AlertController.init().shareViewController(self, image: creation.image, totalMoves: totalMoves), animated: true, completion: nil)
    }
}


