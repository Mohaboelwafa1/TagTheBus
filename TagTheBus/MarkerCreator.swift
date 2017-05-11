//
//  MarkerCreator.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/10/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps


class MarkerCreator {
    
    class func returnMarkerData(coor : CLLocationCoordinate2D , buses : String , street : String , id : String) -> GMSMarker {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coor.latitude, longitude: coor.longitude)
        marker.title = street
        marker.snippet = buses
        marker.userData = id
        
        
        
        return marker
    }
}
