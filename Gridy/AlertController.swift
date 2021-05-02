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
    
    func troubleAlertContoller(message: Messages) -> UIAlertController {
        let alertController = UIAlertController(title: "Oh no!", message: message.rawValue, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        
        return alertController
        
        
        
        
        
        
    }
}
