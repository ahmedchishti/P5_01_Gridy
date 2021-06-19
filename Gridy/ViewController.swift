//
//  ViewController.swift
//  Gridy
//
//  Created by Ahmed Chishti on 1/28/21.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Invoked when user presses one of the following three buttons
    
    @IBAction func pickButton(_ sender: Any) {
        processPicked(image: randomImage())
        performSegue(withIdentifier: "editorSegue", sender: self)
    }
    @IBAction func cameraButton(_ sender: Any) {
        displayCamera()
    }
    @IBAction func libraryButton(_ sender: Any) {
        displayLibrary()
    }
    
    // Connections to storyboard for each of the three buttons
    
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    // Instantiating the imagePickerController, random images array and the creation object
    
    let imagePickerController = UIImagePickerController()
    var randomImages = [UIImage]()
    var creation = Creation.init()
    
    // MARK: Setup
    
    // Invoked after the view loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the three buttons' corner radiuses
        
        let btnRadius = CGFloat(15.0)
        
        pickButton.layer.cornerRadius = btnRadius
        cameraButton.layer.cornerRadius = btnRadius
        photoButton.layer.cornerRadius = btnRadius
        
        // Do any additional setup after loading the view.
        
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // Setting controller delegate to current class
    
    func config() {
        imagePickerController.delegate = self
        randomImages = creation.collectRandomImageSet()
    }
    
    
    // Access to camera and library
    
    func displayCamera() {
        
        // Display device camera, check permission and display any errors to the user
        
        let sourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch status {
            case .notDetermined:
                
                // User hasn't previously given permission
                
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(granted) in
                    if granted {
                        
                        // User has given permission
                        
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        
                        // User doesn't have permission
                        
                        self.present(AlertController.init().troubleAlertContoller(message: .cameraPermisson), animated: true)
                    }
                })
            case .authorized:
                
                // User has previously given permission
                
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                
                // User has denied access
                
                present(AlertController.init().troubleAlertContoller(message: .cameraPermisson), animated: true)
            @unknown default:
                fatalError(Messages.cameraPermisson.rawValue)
            }
        }
        
        // If camera doesn't exist/work
        
        else {
            present(AlertController.init().troubleAlertContoller(message: .cameraError), animated: true)
        }
    }
    
    func displayLibrary() {
        
        // Display photo library, check permission and display any errors to the user
        
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                
                // User has not previously given permission
                
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        
                        // User has given permission
                        
                        // The function below requires that it be run on the main thread
                        
                        DispatchQueue.main.async {
                            self.presentImagePicker(sourceType: sourceType)
                        }
                        
                    } else {
                        
                        // We don't have permisson
                        
                        self.present(AlertController.init().troubleAlertContoller(message: .libraryPermission), animated: true)
                    }
                })
            case .authorized:
                
                // User has previously given permission
                
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                
                // User has denied us access
                
                present(AlertController.init().troubleAlertContoller(message: .libraryPermission), animated: true)
            default:
                present(AlertController.init().troubleAlertContoller(message: .libraryPermission), animated: true)
            }
        }
        else {
            present(AlertController.init().troubleAlertContoller(message: .libraryError), animated: true)
        }
    }
    
    // MARK: Image picking
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        
        // Present image picker
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func randomImage() -> UIImage {
        
        // Function to return random image
        
        randomImages = randomImages.shuffled()
        while creation.image == randomImages.first{
            
            // Check if image isn't the same as current image
            
            randomImages = randomImages.shuffled()
        }
        return randomImages.first!
    }
    
    // Passed image is assigned to creation.image
    
    func processPicked(image: UIImage?) {
        if let newImage = image {
            self.creation.image = newImage
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Once the user has selected image from image picking options, perform segue to edit image
        
        let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        processPicked(image: newImage)
        dismiss(animated: true, completion: { () -> Void in
            self.performSegue(withIdentifier: "editorSegue", sender: self)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Segue Controls
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send selected image to editor segue
        
        if segue.identifier == "editorSegue" {
            let editorViewController = segue.destination as! EditorViewController
            editorViewController.incomingImage = creation.image
        }
    }
    
    @IBAction func unwindToMenu(_ unwindSegue: UIStoryboardSegue) {}
}

