//
//  ViewController.swift
//  getIt
//
//  Created by Ramilia Imankulova on 11/27/18.
//  Copyright © 2018 Ramilia Imankulova. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var takenPicture: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
    
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.takenPicture.image = pickedImage
            guard let ciimage = CIImage(image: pickedImage) else {
                fatalError("Error with converting into CIImage")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func detect(image: CIImage) {
        
            guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {fatalError("Error with detecting")}
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {fatalError("Couldn't get  results")}
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("dyke") {
                    self.navigationItem.title = "Dyke!!!"
                } else {
                    self.navigationItem.title = "Not dyke"
                }
            }
        }
            
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        }


    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
        
}

