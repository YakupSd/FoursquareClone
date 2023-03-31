import Foundation
import UIKit

class SavePlaceModel{
    static let sharedInstance = SavePlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeComment = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(placeName: String = "", placeType: String = "", placeComment: String = "", placeImage: UIImage = UIImage(), placeLatitude: String = "", placeLongitude: String = "") {
        self.placeName = placeName
        self.placeType = placeType
        self.placeComment = placeComment
        self.placeImage = placeImage
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
    }
}
