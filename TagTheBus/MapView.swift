//
//  MapView.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/10/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

class MapView : UIViewController  , GMSMapViewDelegate{
    
    // Objects related to map view we will use it later
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    // An Array of markers will be addded to the map
    var StationsMarkers : [GMSMarker] = [GMSMarker]()
    var mapView : GMSMapView!
    
    override func viewDidLoad() {
        
        // Configure location manager
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        
        // ----- Detect current location for the user
        let camera = GMSCameraPosition.camera(withLatitude: 30.0,longitude: 30.0,zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.delegate = self
        
        // Adding the station markers on the map
        self.AddMarkersToMap()
        
    }
    
    
    
    func AddMarkersToMap() {
        
        // Loop over markers array to create them
        for index in 0...ListOfStations.sharedInstance.stationsList.count-1 {
            
            let lat = Double(ListOfStations.sharedInstance.stationsList[index].lat)
            let lon = Double(ListOfStations.sharedInstance.stationsList[index].lon)
            let buses = String(ListOfStations.sharedInstance.stationsList[index].buses)
            let street = String(ListOfStations.sharedInstance.stationsList[index].street_name)
            let id = String(ListOfStations.sharedInstance.stationsList[index].id)
            
            // Creates a marker in the center of the map.
            let coor = CLLocationCoordinate2D(latitude: lat! , longitude: lon!)
            
            self.StationsMarkers.append(MarkerCreator.returnMarkerData(coor: coor, buses: buses!, street: street!, id: id!))
            
        }
        
        // Adding them to the map
        for index in 0...self.StationsMarkers.count-1 {
            
            self.StationsMarkers[index].map = self.mapView
            
        }
        
        
    }
    
    
    

    // Detect user touch on the marker and navigate to list of images page
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker){
        
        print("stationID is :_>  \(marker.userData!)")
        
        
        // Navigate to the  list page of station images with the full data
        let imagesListView:ListOfImages = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListOfImages") as! ListOfImages
        imagesListView.stationID = String(describing: marker.userData!) // Passing station id to the list of images viewer
        self.present(imagesListView, animated: false, completion: nil)
        
    }
    
    
    
}


extension MapView : CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        mapView.isMyLocationEnabled = true
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        
    }
    
    
    
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    
}

