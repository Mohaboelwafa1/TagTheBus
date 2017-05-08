//
//  ImageViewer.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/7/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation
import UIKit

class ImageViewer : UIViewController {
    
    // Outlet to objects in the interface builder
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // Image title and station ID
    var imageTitle : String!
    var stationID : String!
    
    
    override func viewDidLoad() {
        
        // set the image to the image view
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("/\(stationID!)/\(imageTitle!).jpg")
        if fileManager.fileExists(atPath: imagePAth){
                self.imageView?.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
        }
        
        
        // Set the title of the image to the title label
        self.titleLabel.text = imageTitle!
        
    }
    
    
    // Sharing image on FB , Twitter and mail.
    @IBAction func shareImage(_ sender: Any) {
    }
    
    

    // Close page
    @IBAction func backFunction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Get Documents path
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
}
