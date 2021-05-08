//
//  PuzzleViewController.swift
//  Gridy
//
//  Created by Ahmed Chishti on 5/7/21.
//

import Foundation
import UIKit
import AVFoundation

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
    var score: Int = 0
    var consecutiveCorrectMoves: Int = 0
    var consecutiveIncorrectMoves: Int = 0
    var soundIsOn: Bool = true
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var scoreChangeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var lookupImageView: UIImageView!
    @IBOutlet weak var piecesCollectionView: UICollectionView!
    @IBOutlet weak var boardCollectionView: UICollectionView!
    @IBOutlet weak var piecesCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var boardCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var muteButton: UIButton!
    
    enum placeholderImages: String {
        case blank = "blank"
        case lookup = "Gridy-lookup"
    }
    
    @IBAction func muteButtonAction(_ sender: Any) {
        if soundIsOn == true {
            soundIsOn = false
        } else {
            soundIsOn = true
        }
        updateMute()
    }
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        muteButton.setImage(UIImage(systemName: "speaker.fill"), for: .normal)
        muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .selected)
        
        // Set Delegates for Puzzle View Controller
        configureDelegates(collectionView: piecesCollectionView)
        configureDelegates(collectionView: boardCollectionView)
        
        // Additional Setup
        correctOrderImages = piecesCVImages
        piecesCVImages = piecesCVImages.shuffled()
        lookupImageView.image = creation.image
        lookupImageView.isHidden = true
        scoreChangeLabel.isHidden = true
        updateScore()
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
        piecesCVImages.append(UIImage.init(named: placeholderImages.lookup.rawValue)!)
        piecesCollectionView.reloadData()
        boardCollectionView.reloadData()
    }
    
    func updateMute() {
        if soundIsOn == true {
            muteButton.isSelected = false
        } else {
            muteButton.isSelected = true
        }
    }
    
    // MARK: Scoring
    func updateScore() {
        var increment = 0
        // example: if 3rd correct move in a row the increment would be 1+2+3 = 6
        if consecutiveCorrectMoves > 0 {
            for i in 1 ... consecutiveCorrectMoves {
                increment += i
            }
            // the opposite applies for wrong moves: -1-2-3 = -6
        } else if consecutiveIncorrectMoves > 0 {
            for i in 1 ... consecutiveIncorrectMoves {
                increment -= i
            }
        }
        // score can't drop below zero
        if (score + increment) >= 0 {
            score += increment
        } else {
            increment = score * -1
            score = 0
        }
        
        // display the change in score
        scoreChangeLabel.isHidden = false
        scoreLabel.text = String(score)
        movesLabel.text = String(totalMoves)
        
        if increment > 0 {
            scoreChangeLabel.text = "+\(increment)"
            scoreChangeLabel.textColor = UIColor.init(red: 136/255, green: 212/255, blue: 152/255, alpha: 1)
        } else if increment < 0 {
            scoreChangeLabel.text = String(increment)
            scoreChangeLabel.textColor = UIColor.red
        }else {
            scoreChangeLabel.text = "0"
            scoreChangeLabel.textColor = UIColor.black
        }
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.hideScoreChangeLabel), userInfo: nil, repeats: false)
    }
    
    @objc func hideScoreChangeLabel() {
        scoreChangeLabel.isHidden = true
    }
    
    // MARK: Gameover
    func endGame() {
        present(AlertController.init().endGameAlertController(self, score: score, totalMoves: totalMoves), animated: true)
    }
    
    func displaySharingOptions(){
        present(AlertController.init().shareViewController(self, image: creation.image, totalMoves: totalMoves, score: score), animated: true, completion: nil)
    }
}


