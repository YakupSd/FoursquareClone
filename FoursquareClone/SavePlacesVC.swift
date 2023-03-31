//
//  SavePlacesVC.swift
//  FoursquareClone
//
//  Created by Yakup Suda on 4.03.2023.
//

import UIKit

class SavePlacesVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {



    @IBOutlet weak var placeComment: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRegocnizer = UITapGestureRecognizer(target: self, action: #selector(ChooseImage))
        imageView.addGestureRecognizer(gestureRegocnizer)
        

        
    }
    @objc func ChooseImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(inputError : String, inputMessage : String){
        let alert = UIAlertController(title: inputError, message: inputMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Error", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }


    @IBAction func nextButtonClicked(_ sender: Any) {
        if placeName.text != "" && placeType.text != "" && placeComment.text != "" {
            if let choosenImage = imageView.image {
                let placeModel = SavePlaceModel.sharedInstance
                placeModel.placeName = placeName.text!
                placeModel.placeType = placeType.text!
                placeModel.placeComment = placeComment.text!
                placeModel.placeImage = choosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }else{
            makeAlert(inputError: "Error", inputMessage: "Place Name / Type / Comment ?")
        }
        
    }
    
}

/*
 
 */
