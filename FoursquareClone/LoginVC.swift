//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Yakup Suda on 3.03.2023.
//

import UIKit
import Parse
class LoginVC: UIViewController {

    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*/
        //veri kaydetme
        let parseObject = PFObject(className: "Fruits")
        parseObject["name"] = "Orange"
        parseObject["Calories"] = 167
        // parseObject.saveInBackground() Hemen kaydet hata varsa hata ver
        // parseObject.saveEventually() bağlantı olmasa bile olduğunda kaydeder
        parseObject.saveInBackground { success, error in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                print("Success")
            }
        }
        //veri çekme işlemleri
        let query = PFQuery(className: "Fruits")
        
       // query.whereKey("name", equalTo: "Apple") isme göre çekme
        query.whereKey("Calories", greaterThan: 140) // filtreleme işlmei
        query.findObjectsInBackground { objects, error in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                print(objects)
            }
        }*/
        
        /*current user alma
        
        let currentUser = PFUser.current()
        if currentUser != nil {
            performSegue(withIdentifier: "toPlacesVC", sender: nil)
        }
        */
    }

    @IBAction func singInClicked(_ sender: Any) {
        if usernameText.text != "" && passText.text != ""{
            
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passText.text!) { user, error in
                if error != nil {
                    self.makeAlert(InputError: "Error", InputMessage: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }else {
            makeAlert(InputError: "Error", InputMessage: "Username / Pass ?")
        }
    }
    
    @IBAction func singUpCliecked(_ sender: Any) {
        performSegue(withIdentifier: "toSingUpVC", sender: nil)
    }
    
    
    func makeAlert(InputError : String, InputMessage : String){
        let alert = UIAlertController(title: InputError, message: InputMessage, preferredStyle: UIAlertController.Style.alert)
        let adButton = UIAlertAction(title: "Error!", style: UIAlertAction.Style.default)
        alert.addAction(adButton)
        self.present(alert, animated: true)
        
    }
}

