//
//  TakePicture.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/3/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TakePictureView: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
 
    var comingImage     : UIImage!
    var comingStationID : String!
    
    override func viewDidLoad() {

        // Title txt field
        self.titleTxtField.delegate = self
        
        // get image from camera
        imageView.image = comingImage
        
        // get current date and time
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        
        
        let calendar = NSCalendar.current
        let hour = String(calendar.component(.hour, from: date))
        let minutes = String(calendar.component(.minute, from: date))
        let sec = String(calendar.component(.second, from: date))
        let time = ("."+hour+"."+minutes+"."+sec) as String
        
        
        timeLabel.text = result + time
        
    }
    
    
    // save image to documents
    @IBAction func saveAction(_ sender: Any) {
        
        // Create directory to each sation
        createDirectory()
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(self.comingStationID!)/\(titleTxtField.text!).jpg")
        
//        print("=====")
//        print(paths)
        
        let image = comingImage
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let savedImage = SavedImage(context: context) // Link Images & Context
        
        savedImage.stationID = comingStationID
        savedImage.name = titleTxtField.text
        savedImage.time = timeLabel.text
        
        
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

     
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(self.comingStationID!)")
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
            
            print("New Directory has been created.!!")
            
        }else{
            print("Already Directory created.")
        }
    }
    
    
    
    // Close page
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Close keypad
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
}
