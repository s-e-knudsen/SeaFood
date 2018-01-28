//
//  ViewController.swift
//  SeaFood
//
//  Created by Søren Knudsen on 28/01/2018.
//  Copyright © 2018 Søren Knudsen. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedimage
            
            
            guard let ciimage = CIImage(image: userPickedimage) else {
                fatalError("Could not convert image")
            }
            
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
       
    }
    
    //MARK: - Detect the image using ML CoreML
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        let request = VNCoreMLRequest(model: model) { (recuest, error) in
            guard let results = recuest.results as? [VNClassificationObservation] else {
                fatalError("Error getting the result")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog"
                } else {
                    self.navigationItem.title = "Not Hotdog"
                }
            }
            
            
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Image picker setup
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
        
    }

  


}

