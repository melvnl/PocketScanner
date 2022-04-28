//
//  CameraViewController.swift
//  PocketScanner
//
//  Created by melvin on 26/04/22.
//

import UIKit
import Vision
import VisionKit

class CameraViewController: UIViewController,UITextViewDelegate {
    
    var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)

    @IBOutlet weak var ocrTextView: UITextView!
    
    @IBOutlet weak var myImg: UIImageView!
    @IBOutlet weak var scanButton: UIButton!
    
    @IBAction func openCamera(_ sender: Any) {
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
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
        
        configureOCR()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc private func scanDocument() {
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }
    
    
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        ocrTextView.text = ""
        scanButton.isEnabled = false
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([self.ocrRequest])
        } catch {
            print(error)
        }
    }
    
    func configureOCR() {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

        var ocrText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }

                ocrText += topCandidate.string + "\n"
            }

            DispatchQueue.main.async {
                self.ocrTextView.text = ocrText
                self.scanButton.isEnabled = true
            }
        }
            
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        ocrRequest.usesLanguageCorrection = true
         
    }

}

extension CameraViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        myImg.image = scan.imageOfPage(at: 0)
        processImage(scan.imageOfPage(at: 0))
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        //Handle properly error
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}


