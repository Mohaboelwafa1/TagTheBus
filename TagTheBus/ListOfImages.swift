//
//  ListOfImages.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/3/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation
import UIKit

class ListOfImages: UIViewController , UITableViewDataSource , UITableViewDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var imagePickerController: UIImagePickerController!
    
    
    
    override func viewDidLoad() {
        // ----
    }
    
    
    @IBAction func addNewImage(_ sender: Any) {
        
        
        
        imagePickerController =  UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        
        print("_____________")
        let imageSaver :TakePictureView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TakePictureView") as! TakePictureView
        
        imageSaver.comingImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.present(imageSaver, animated: false, completion: nil)
    }
    
    
    @IBAction func closeView(_ sender: Any) {
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        
        
        // asign the data to the labels
        cell.textLabel?.text = "-----"
        cell.detailTextLabel?.text = "======"
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "add")
        
        
        // set the first image to the image view
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("er03.05.2017.21.54.3.jpg")
             cell.imageView?.image = UIImage(contentsOfFile: imageURL.path)
            
            
        }
        
        
        return cell
        
    }
    
//    func getImage()-> UIImage{
//        let fileManager = FileManager.default
//        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("er03.05.2017.21.54.3.jpg")
//        if fileManager.fileExists(atPath: imagePAth){
//            print("__imagePAth_____\(imagePAth)")
//            //self.imageView.image = UIImage(contentsOfFile: imagePAth)
//        }else{
//            print("No Image")
//        }
//    }
//    
//    func getDirectoryPath() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
    
    
}
