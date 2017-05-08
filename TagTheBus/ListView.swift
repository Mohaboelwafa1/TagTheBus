//
//  ListView.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/3/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class ListView: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    // outlet to the table view in the interface builder
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        // tableview delegate
        self.tableView.delegate = self
        
        // get data from server
        self.getDataFromServer()
        
        
        
    }
    
    
    // Number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // Number of rows in the table == count of the array that holding sations data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListOfStations.sharedInstance.stationsList.count
    }
    
    
    
    // Draw each cell in the row of the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        
        
        // asign the data to the labels
        cell.textLabel?.text = ListOfStations.sharedInstance.stationsList[indexPath.row].city                 // City name
        cell.detailTextLabel?.text = ListOfStations.sharedInstance.stationsList[indexPath.row].street_name    // Street name of the station
        cell.accessoryType = .disclosureIndicator                                                             // -> the arrow in the cell
        
        return cell
        
    }
    
    
    //  When user touch one cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        // Navigate to the  list page of station images with the full data
        let imagesListView:ListOfImages = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListOfImages") as! ListOfImages
        imagesListView.stationID = ListOfStations.sharedInstance.stationsList[indexPath.row].id // Passing station id to the list of images viewer
        self.present(imagesListView, animated: false, completion: nil)
        
        
    }
    
    
    
    // Fetch data from server
    func getDataFromServer(){
        
        Alamofire.request("http://barcelonaapi.marcpous.com/bus/nearstation/latlon/41.3985182/2.1917991/1.json").responseJSON { response in
            
            if let json = response.result.value {
                let JSON            = json as! NSDictionary
                let data            = JSON["data"] as! NSDictionary
                let nearstations    = data["nearstations"] as! NSArray   // Stations Array
                
                //print("------\(nearstations[0])")
                
                // Loop over the array to fill the singleton class with station (model) coming from the server
                for index in 0...nearstations.count-1 {
                    
                    let model : StaionModel = StaionModel()
                    let row = nearstations[index] as! NSDictionary
                    
                    model.buses         =  row["buses"] as! String
                    model.city          =  row["city"] as! String
                    model.distance      =  row["distance"]  as! String
                    model.furniture     =  row["furniture"]  as! String
                    model.id            =  row["id"]  as! String
                    model.lat           =  row["lat"]  as! String
                    model.lon           =  row["lon"]  as! String
                    model.street_name   =  row["street_name"]  as! String
                    model.utm_x         =  row["utm_x"]  as! String
                    model.utm_y         =  row["utm_y"]  as! String
                    
                    
                    ListOfStations.sharedInstance.addToStationsList(listAsParamter: model)
                    
                }
                
                
            }
            
            // Refresh table after loading data
            DispatchQueue.main.async(execute: {self.do_table_refresh()})
        }
        
    }
    
    
    // Refreshing table view to get data
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }
    
}
