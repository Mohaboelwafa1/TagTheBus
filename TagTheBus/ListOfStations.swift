//
//  ListOfStations.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/3/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//
import Foundation

class ListOfStations {
    
    // Declare our 'sharedInstance' property
    static let sharedInstance = ListOfStations();
    
    var stationsList :[StaionModel] = [StaionModel]()
    
    func addToStationsList(listAsParamter : StaionModel) {
        self.stationsList.append(listAsParamter)
    }
    
}

