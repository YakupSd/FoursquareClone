//
//  SingUpViewController.swift
//  FoursquareClone
//
//  Created by Yakup Suda on 4.03.2023.
//

import UIKit
import Parse

class SingUpViewController: UIViewController {

    @IBOutlet weak var repassText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func singUpCliecked(_ sender: Any) {
        if usernameText.text != "" && emailText.text != "" && passText.text != "" && repassText.text != "" {
            
            if passText.text == repassText.text {
                
                let user = PFUser()
                user.username = usernameText.text!
                user.email = emailText.text!
                user.password = passText.text!
                user.signUpInBackground { success, error in
                    if error != nil {
                        self.MakeAlert(errorInput: "Error", messageInput: error?.localizedDescription ?? "Error!!")
                    }else {
                        //self.MakeAlert(errorInput: "Success", messageInput: "Successfully registered")
                        self.performSegue(withIdentifier: "toSingInVC", sender: nil)
                    }
                }
                
            }else{
                MakeAlert(errorInput: "Error", messageInput: "Password does not match")
            }
            
        }else {
            MakeAlert(errorInput: "Error", messageInput: "Please write currect words")
        }
        
    }
    
    @IBAction func backClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSingInVC", sender: nil)
    }
    func MakeAlert(errorInput : String, messageInput : String){
        let alert = UIAlertController(title: errorInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Error", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    

}
