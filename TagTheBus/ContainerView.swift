//
//  ViewController.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/3/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import UIKit

class ContainerView: UIViewController {
    
    // refrences to objects in the interface builder
    
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var getCurrentLocationButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewSwitcherSegmentedController: UISegmentedControl!
    
    
    var listOfMapStations:MapView!
    var listOfStations:ListView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // First time open list view
        self.openListView()
        
    }
    
    // Detect user click (touch) to switch between list and map views
    @IBAction func switchViewsFunction(_ sender: UISegmentedControl) {
    
        let ch = sender.selectedSegmentIndex
        
        switch ch {
        case 0:
            if (self.listOfStations != nil) {
                self.listOfStations.view.removeFromSuperview()
            }
            openMapView()
            
        case 1:
            if (self.listOfMapStations != nil) {
                self.listOfMapStations.view.removeFromSuperview()
            }
            openListView()
        default: break
            
        }
    }
    
    
    
    
    func openMapView()  {
        // Navigate to the sations list map page with the full data
        self.listOfMapStations = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapView") as! MapView
        self.listOfMapStations.view.frame = CGRect(x: 0, y: 0, width: self.mainView.frame.size.width, height: self.mainView.frame.size.height)
        self.mainView.addSubview(listOfMapStations.view)
        self.addChildViewController(listOfMapStations)
        
    }
    
    func openListView() {
        // Navigate to the sations list page with the full data
        
        self.listOfStations = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listOfStations") as! ListView
        self.listOfStations.view.frame = CGRect(x: 0, y: 0, width: self.mainView.frame.size.width, height: self.mainView.frame.size.height)
        self.mainView.addSubview(listOfStations.view)
        self.addChildViewController(listOfStations)
    }
}

