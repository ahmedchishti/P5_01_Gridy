//
//  EditorViewController.swift
//  Gridy
//
//  Created by Ahmed Chishti on 5/1/21.
//

import Foundation
import UIKit
import Photos
import AVFoundation

class EditorViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var creationImageView: UIImageView!
    @IBOutlet weak var hiddenCreationImageView: UIImageView!
    @IBOutlet weak var gridImageView: UIImageView!
    @IBOutlet weak var creationFrame: UIView!
    
    @IBAction func startButton(_ sender: Any) {
        creation.image = composeCreationImage()
        preparePuzzleImages()
        performSegue(withIdentifier: "puzzleSegue", sender: self)
    }
    
    var incomingImage: UIImage?
    var creation = Creation.init()
    var initalImageViewOffset = CGPoint()
    let defaults = UserDefaults.standard
    var puzzleImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        
        config()
    }
    
    func config() {
        
        // Set default settings
        
        setImage()
        
        // Set up gesture recognizers
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_sender:)))
        gridImageView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(_sender:)))
        gridImageView.addGestureRecognizer(pinchGestureRecognizer)
        pinchGestureRecognizer.delegate = self
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateImageView(_sender:)))
        gridImageView.addGestureRecognizer(rotationGestureRecognizer)
        rotationGestureRecognizer.delegate = self
        
    }
    
    func setImage() {
        if let image = incomingImage {
            creationImageView.image = image
            hiddenCreationImageView.image = image
        }
    }
        
    // MARK: Gesture Recognisers
    
    @objc func moveImageView(_sender: UIPanGestureRecognizer){
        let translation = _sender.translation(in: gridImageView.superview)
        
        if _sender.state == .began || _sender.state == .changed {
            creationImageView.center = CGPoint(x: creationImageView.center.x + translation.x, y: creationImageView.center.y + translation.y)
            _sender.setTranslation(CGPoint.zero, in: creationImageView)
            hiddenCreationImageView.center = CGPoint(x: hiddenCreationImageView.center.x + translation.x, y: hiddenCreationImageView.center.y + translation.y)
            _sender.setTranslation(CGPoint.zero, in: hiddenCreationImageView)
        }
    }
    
    @objc func scaleImageView(_sender: UIPinchGestureRecognizer){
        creationImageView.transform = creationImageView.transform.scaledBy(x: _sender.scale, y: _sender.scale)
        _sender.scale = 1
        hiddenCreationImageView.transform = creationImageView.transform.scaledBy(x: _sender.scale, y: _sender.scale)
        _sender.scale = 1
    }
    
    @objc func rotateImageView(_sender: UIRotationGestureRecognizer){
        creationImageView.transform = creationImageView.transform.rotated(by: _sender.rotation)
        _sender.rotation = 0
        hiddenCreationImageView.transform = creationImageView.transform.rotated(by: _sender.rotation)
        _sender.rotation = 0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer:UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view != gridImageView {
            return false
        }
        // User can't move image at the same time as other transformations
        
        if gestureRecognizer is UIPanGestureRecognizer || otherGestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Handling Image
    func composeCreationImage() -> UIImage {
        
        // Return screenshot of edited image
        
        UIGraphicsBeginImageContextWithOptions(creationFrame.bounds.size, false, 0 )
        creationFrame.drawHierarchy(in: creationFrame.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    func preparePuzzleImages() {
        puzzleImages.removeAll()
        puzzleImages = slice(screenshot: creation.image)
    }
    
    func slice(screenshot: UIImage) -> [UIImage] {
        
        //Slice screenshot into puzzle pieces
        
        
        let width = screenshot.size.height
        let height = screenshot.size.height
        
        let tileWidth = Int(width / CGFloat(4))
        let tileHeight = Int(height / CGFloat(4))
        
        let scale = Int(screenshot.scale)
        var images = [UIImage]()
        
        let cgImage = screenshot.cgImage!
        
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< 4 {
            if row == (3) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< 4 {
                if column == (3) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: screenshot.scale, orientation: screenshot.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "puzzleSegue" {
            let puzzleViewController = segue.destination as! PuzzleViewController
            puzzleViewController.piecesCVImages = puzzleImages
            puzzleViewController.creation = creation
        }
    }
    
}
