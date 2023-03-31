//
//  PlacesViewController.swift
//  FoursquareClone
//
//  Created by Yakup Suda on 4.03.2023.
//

import UIKit
import Parse

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceID = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigation bara ekleme butonu için gereke kod
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClick))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(logOutButton))
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
        
    }
    
    func getDataFromParse(){
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects , error) in
            if error != nil{
                self.makeAlert(InputError: "Error", InputMessage: error?.localizedDescription ?? "Error")
            }else{
                if objects != nil {
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    for object in objects! {
                        if let placeName = object.object(forKey: "PlacesName") as? String {
                            if let placeId = object.objectId {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func addButtonClick(){
        self.performSegue(withIdentifier: "toSavePlaceVC", sender: nil)
    }
    
    @objc func logOutButton(){
        PFUser.logOutInBackground { error in
            if error != nil{
                self.makeAlert(InputError: "Error", InputMessage: error?.localizedDescription ?? "Error")
            }else{
                self.performSegue(withIdentifier: "toLoginVC", sender: nil)
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue olmadan önce ne yapcağımız
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenPlaceId = selectedPlaceID
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //satıra tıklandığında yapmak istenilen
        selectedPlaceID = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func makeAlert(InputError : String, InputMessage : String){
        let alert = UIAlertController(title: InputError, message: InputMessage, preferredStyle: UIAlertController.Style.alert)
        let adButton = UIAlertAction(title: "Error!", style: UIAlertAction.Style.default)
        alert.addAction(adButton)
        self.present(alert, animated: true)
        
    }
}
