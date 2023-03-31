//
//  DetailsViewController.swift
//  FoursquareClone
//
//  Created by Yakup Suda on 6.03.2023.
//

import UIKit
import MapKit
import Parse

class DetailsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var dtNameLabel: UILabel!
    @IBOutlet weak var dtMapView: MKMapView!
    @IBOutlet weak var dtCommentsLabel: UILabel!
    @IBOutlet weak var dtTypeLabel: UILabel!
    @IBOutlet weak var dtImageView: UIImageView!
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    var chosenPlaceId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        getDataFromParse()
        dtMapView.delegate = self
        
        
    }
    
    func makeAlert(InputError : String, InputMessage : String){
        let alert = UIAlertController(title: InputError, message: InputMessage, preferredStyle: UIAlertController.Style.alert)
        let adButton = UIAlertAction(title: "Error!", style: UIAlertAction.Style.default)
        alert.addAction(adButton)
        self.present(alert, animated: true)
        
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)// database deki object ıd ile seçilen aynı ise getir
        query.findObjectsInBackground { (objects , error) in
            if error != nil {
                self.makeAlert(InputError: "Error", InputMessage: error?.localizedDescription ?? "Error")
            }else {
                if objects != nil{
                    if objects!.count > 0 {
                        let chosenPlaceObject = objects![0]
                        
                        if let placeName = chosenPlaceObject.object(forKey: "PlacesName") as? String{
                            if let placeType = chosenPlaceObject.object(forKey: "PlacesType") as? String{
                                if let placeComment = chosenPlaceObject.object(forKey: "PlacesComment") as? String {
                                    
                                            self.dtNameLabel.text = placeName
                                            self.dtTypeLabel.text = placeType
                                            self.dtCommentsLabel.text = placeComment
                                }
                            }
                        }
                        
                        if let placeLatitude = chosenPlaceObject.object(forKey: "Latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        if let placeLongitude = chosenPlaceObject.object(forKey: "Longitude") as? String{
                            if let placeLongitudeDouble = Double(placeLongitude){
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        if let imageData = chosenPlaceObject.object(forKey: "Image") as? PFFileObject {
                            imageData.getDataInBackground { data, error in
                                if error == nil {
                                    if data != nil {
                                        self.dtImageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        
                        //maps kısmı
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.dtMapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.dtNameLabel.text
                        annotation.subtitle = self.dtTypeLabel.text
                        self.dtMapView.addAnnotation(annotation)
                    }
                }
            }
            
        }
    }
    
    //harita işlemleri navigasyon için
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocaiton = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocaiton) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark) // navigasyon açamk için lazım
                        mapItem.name = self.dtNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions : launchOptions)
                    }
                }
            }
        }
    }
   
}
