//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Yakup Suda on 4.03.2023.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager() // harita işlevi için
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButton))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButton))
        
        //Harita işlemleri, bu iki değer tanımlanmalı( MKMapViewDelegate, CLLocationManagerDelegate)
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // en yakın sonuç için
        locationManager.requestWhenInUseAuthorization() // sadece kullandığım zaman göster
        locationManager.startUpdatingLocation()
        
        //Haritaya tıklamaj ve pin yerleştirmek için gereken işlemler
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation)) // tanımlama işlemi
        recognizer.minimumPressDuration = 2 // kaç saniyer basılı tutarsa çıksın
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    @objc func chooseLocation(gestureRecognizer : UITapGestureRecognizer){
        //basıldığında olması gereken
        if gestureRecognizer.state == UIGestureRecognizer.State.began { //tıklanma işlemi başlatıldı ise yapılmsaı gereken işlem
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView) //tıklanılan yeri view kullanarak kordinata çevirme işlemi
            
            let annotation = MKPointAnnotation() // pin işlemleri
            annotation.coordinate = coordinates
            annotation.title = SavePlaceModel.sharedInstance.placeName
            annotation.subtitle = SavePlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            SavePlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            SavePlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
            
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // enlem boylam işlemi
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035) // zoom için gereken yer ne kadar küçük o kadar zoom
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    @objc func saveButton(){
        //parse
        let currentUser = PFUser.current()
        let object = PFObject(className: "Places")
        let placeModel = SavePlaceModel.sharedInstance
        
        object["Username"] = currentUser?.username
        object["PlacesName"] = placeModel.placeName
        object["PlacesType"] = placeModel.placeType
        object["PlacesComment"] = placeModel.placeComment
        object["Latitude"] = placeModel.placeLatitude
        object["Longitude"] = placeModel.placeLongitude
        //görsel kaydetme
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            object["Image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground { success, error in
            if error != nil {
                self.makeAlert(inputError: "Error", inputMessage: error?.localizedDescription ?? "Error")
            }else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }
    
    @objc func backButton(){
        // navigationController?.popViewController(animated: true) bunu burda kullanamayız çünki iki adet navigation bar var
        self.dismiss(animated: true)
    }
    func makeAlert(inputError : String, inputMessage : String){
        let alert = UIAlertController(title: inputError, message: inputMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Error", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    

   

}
