//
//  DocumentHandler.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/7/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation

class DocumentHandler {
    
    
    // Get Documents path
    class func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
}
