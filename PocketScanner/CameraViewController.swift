//
//  CameraViewController.swift
//  PocketScanner
//
//  Created by melvin on 26/04/22.
//

import UIKit
import Vision

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)

    @IBOutlet weak var ocrTextView: UITextView!
    
    @IBOutlet weak var myImg: UIImageView!
    @IBOutlet weak var scanButton: UIButton!
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    let imagePicker = UIImagePickerController()
                print("Button capture")
                    imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage imagePicker: UIImage!, editingInfo: NSDictionary!){
            self.dismiss(animated: true, completion: { () -> Void in

            })

            myImg.image = imagePicker
        }
    
    func imagePickerControllerDidCancel(
      _ picker: UIImagePickerController
    ) {
      dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
