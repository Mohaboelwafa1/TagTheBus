//
//  ListOfImages.swift
//  TagTheBus
//
//  Created by mohamed hassan on 5/3/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ListOfImages: UIViewController , UITableViewDataSource , UITableViewDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var imagePickerController: UIImagePickerController!
    
    var stationID : String!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var images : [SavedImage] = [SavedImage]()
    
    
    override func viewDidLoad() {

        tableView.delegate = self
        tableView.dataSource = self
    
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
        print("@@@$@#$@#$@$@#$@$#@#@$@$@$#")
        print(directoryContents)
        }
        catch {
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }

    
    func getData() {
        do {
            images = try context.fetch(SavedImage.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
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
        imageSaver.comingStationID = self.stationID
        
        self.present(imageSaver, animated: false, completion: nil)
    }
    
    
    @IBAction func closeView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        

        
        
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "add")
        
        
        
        let image = images[indexPath.row]
        
        if let ID = image.stationID {
            
            
            if ID == stationID {
                
                let name = image.name
                
                let time = image.time
                
                print("bbbbbbbbb")
                print(ID)
                print(stationID)
                
                print(name!)
                print(image.name!)
                
                print(time)
                
        
                // set the first image to the image view
                let fileManager = FileManager.default
                let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("/\(ID)/\(image.name!).jpg")
                
                print("__imagePAth_____\(imagePAth)")
                
                if fileManager.fileExists(atPath: imagePAth){
                    print("__imagePAth_____\(imagePAth)")
                    cell.imageView?.image = UIImage(contentsOfFile: imagePAth)
                }else{
                    print("No Image")
                }
                
                
                cell.textLabel?.text = name
                cell.detailTextLabel?.text = time
                
                
            }
        }
        
        
        
 
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let image = images[indexPath.row]
            context.delete(image)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                images = try context.fetch(SavedImage.fetchRequest())
            } catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
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
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
}
