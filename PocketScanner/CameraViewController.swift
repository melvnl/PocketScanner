//
//  CameraViewController.swift
//  PocketScanner
//
//  Created by melvin on 26/04/22.
//

import UIKit
import Vision

class CameraViewController: UIViewController, UIImagePickerControllerDelegate,UITextViewDelegate,  UINavigationControllerDelegate {
    
    var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)

    @IBOutlet weak var ocrTextView: UITextView!
    
    @IBOutlet weak var myImg: UIImageView!
    @IBOutlet weak var scanButton: UIButton!
    var imagePicker = UIImagePickerController()
    
    @IBAction func openCamera(_ sender: Any) {
        imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let selectedImage = info[.originalImage] as? UIImage {
                myImg.image = selectedImage
            } else {
                print("Image not found")
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ocrTextView.delegate = self

        // Do any additional setup after loading the view.
        myImg.layer.borderWidth = 1
        myImg.layer.borderColor = UIColor.black.cgColor
        myImg.layer.cornerRadius = 8
        
        ocrTextView.layer.borderWidth = 1
        ocrTextView.layer.borderColor = UIColor.black.cgColor
        ocrTextView.layer.cornerRadius = 8
        ocrTextView.backgroundColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
//    func configureOCR() {
//        ocrRequest = VNRecognizeTextRequest { (request, error) in
//        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
//
//        var ocrText = ""
//            for observation in observations {
//                guard let topCandidate = observation.topCandidates(1).first else { return }
//
//                ocrText += topCandidate.string + "\n"
//            }
//
//            DispatchQueue.main.async {
//                self.ocrTextView.text = ocrText
//                self.scanButton.isEnabled = true
//            }
//        }
            
//        ocrRequest.recognitionLevel = .accurate
//        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
//        ocrRequest.usesLanguageCorrection = true
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


