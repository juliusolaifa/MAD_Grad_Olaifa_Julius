//
//  PredictionController.swift
//  MAD_Grad_Olaifa_Julius
//
//  Created by Julius Olaifa on 4/27/22.
//

import UIKit
import CoreML
import Vision


class PredictionController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var uilabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    // This function takes the image taken by the user's camera and sent to the detect function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedimage
            
            guard let ciimage = CIImage(image: userPickedimage)  else {
                fatalError("Could not convert to CIImage")
            }
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    // The detect function detects image and calls the .mlmodel for prediction
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: BoxCarsClassification_1().model) else {
            fatalError("Loading CoreML failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            if let firstResult = results.first {
                //self.navigationItem.title = firstResult.identifier.description
                self.uilabel.text = "Predicted Class: " + firstResult.identifier.description
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    // This IBAction is used to capture the image and given to the UIimage picker controller
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}
