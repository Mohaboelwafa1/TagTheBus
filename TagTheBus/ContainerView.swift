//
//  ViewController.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/3/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import UIKit

class ContainerView: UIViewController {

    
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var getCurrentLocationButton: UIButton!
    //@IBOutlet weak var switchViewsSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigate to the book list page with the full data
        let listOfStations:ListView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listOfStations") as! ListView
        
        self.mainView.addSubview(listOfStations.view)
        self.addChildViewController(listOfStations)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

