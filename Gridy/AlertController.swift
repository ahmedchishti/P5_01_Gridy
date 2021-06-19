//
//  AlertController.swift
//  Gridy
//
//  Created by Ahmed Chishti on 4/18/21.
//

import Foundation
import UIKit

enum Messages: String {
    
    case cameraPermisson = "Looks like Gridy doesn't have access to your camera. Please use the Settings app on your device to allow Gridy to access your camera."
    case cameraError = "Sorry! Looks like we can't access your camera at this time."
    case libraryPermission = "Looks like Gridy haven't access to your photos. Please use the Settings app on your device to allow Gridy to access your library"
    case libraryError = "Sorry! Looks like we can't access your photo library at this time."
}

class AlertController {
    
    init() {
        
    }
    
    // Shows alert for end game, includes share and new game option
    
    func endGameAlertController(_ sender: PuzzleViewController, totalMoves: Int) -> UIAlertController {
        let alertController = UIAlertController(title: "Congratulations!", message: "Score: \(totalMoves)", preferredStyle: .alert)
        let newGame = UIAlertAction(title: "New Game", style: .default) {(action) in
            sender.performSegue(withIdentifier: "Menu", sender: nil)
        }
        alertController.addAction(newGame)
        let share = UIAlertAction(title: "Share", style: .default) {(action) in
            sender.displaySharingOptions()
        }
        alertController.addAction(share)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(cancel)
        return alertController
    }
    
    // Shows sharing options with the following note: I completed this puzzle in # moves!
    
    func shareViewController(_ sender: PuzzleViewController, image: UIImage, totalMoves: Int) -> UIActivityViewController {
        let note = "I completed this puzzle in \(totalMoves) moves!"
        let items = [note as Any, image as Any]
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender.view
        
        return activityViewController
    }
    
    // Shows trouble alert controller
    
    func troubleAlertContoller(message: Messages) -> UIAlertController {
        let alertController = UIAlertController(title: "Oh no!", message: message.rawValue, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        
        return alertController
    }
    
    // Shows score alert controller which includes both previous and high scores
    
    func scoreAlertController(previousScore: String, highScore: String) -> UIAlertController {
        
        let message = "The high score is: " + highScore + "\nThe previous score was: " + previousScore 
        let alertController = UIAlertController(title: "Scores", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        let resetAction = UIAlertAction(title: "Reset", style: .cancel) {_ in
            self.resetScore()
            
        }
        alertController.addAction(okayAction)
        alertController.addAction(resetAction)
        
        return alertController
    }
    
    // Invoked when the user presses reset, which proceeds to wipe the previous and high score 
    
    func resetScore() {
        UserDefaults.standard.set(0, forKey: "PreviousScore")
        UserDefaults.standard.set(0, forKey: "HighScore")
    }
    
}
