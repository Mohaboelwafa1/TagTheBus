//
//  TakePicture.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/3/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation
import UIKit

class TakePictureView: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
 
    var comingImage : UIImage!
    override func viewDidLoad() {

        
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
    
    
    @IBAction func saveAction(_ sender: Any) {
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(titleTxtField.text! + timeLabel.text!).jpg")
        let image = comingImage
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
     
        self.getImage()
        
    }
    
    func getImage(){
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(titleTxtField.text! + timeLabel.text!).jpg")
        if fileManager.fileExists(atPath: imagePAth){
            print("__imagePAth_____\(imagePAth)")
            //self.imageView.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func cancelAction(_ sender: Any) {
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
}
