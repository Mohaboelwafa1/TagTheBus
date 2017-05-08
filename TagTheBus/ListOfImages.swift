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
    
    // Outlet to the objects in the interface builder
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // Camera controller
    var imagePickerController: UIImagePickerController!
    
    // Sation ID
    var stationID : String!
    
    // Context (sqlite DB holding images)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Images from DB
    var images : [SavedImage] = [SavedImage]()
    
    // Filtering images array to get only images of this station
    var currentStationImages : [ImageModel] = [ImageModel]()
    
    override func viewDidLoad() {
        
        // Table view delegate & data source
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Get data from DB
        getData()
        
        // Reload table after getting images from DB
        tableView.reloadData()
    }
    
    
    func getData() {
        
        // claer current images array
        currentStationImages.removeAll()
        
        do {
            images = try context.fetch(SavedImage.fetchRequest())
            
            // Loop in the full array : if station IDs are equal append the image to the current image array
            for index in 0...images.count-1 {
                
                if (images[index].stationID == stationID){
                    let imageModel : ImageModel = ImageModel()
                    
                    imageModel.imageIndex = Int(index)
                    imageModel.name = images[index].name!
                    imageModel.stationID = images[index].stationID!
                    imageModel.time = images[index].time!
                    
                    currentStationImages.append(imageModel)
                }
                
                
            }
        }
        catch {
            print("Fetching Failed")
        }
        
    }
    
    
    @IBAction func addNewImage(_ sender: Any) {

        // Open camera to take a pic
        imagePickerController =  UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Passing image to the image view page to get title and save it to the DB
        
        imagePickerController.dismiss(animated: true, completion: nil)
        let imageSaver :TakePictureView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TakePictureView") as! TakePictureView
        imageSaver.comingImage = info[UIImagePickerControllerOriginalImage] as? UIImage   // Passing the image
        imageSaver.comingStationID = self.stationID                                       // Passing the station ID
        self.present(imageSaver, animated: false, completion: nil)
    }
    
    
    // Close the view
    @IBAction func closeView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    // Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    // Number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows is count of current images array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentStationImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        
        
        
        
        cell.accessoryType = .disclosureIndicator     // -> arrow in the cell
        cell.imageView?.image = UIImage(named: "add") // Default image
        
        
        cell.textLabel?.text = currentStationImages[indexPath.row].name         // Image name
        cell.detailTextLabel?.text = currentStationImages[indexPath.row].time  // Image time
        
        // set the image to the image view
        let fileManager = FileManager.default
        let imagePAth = (DocumentHandler.getDirectoryPath() as NSString).appendingPathComponent("/\(stationID!)/\(currentStationImages[indexPath.row].name).jpg")
        
        if fileManager.fileExists(atPath: imagePAth){
            cell.imageView?.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
        }
        
  
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            currentStationImages.remove(at: indexPath.row)               // Delete image from sub array
            
            let index = currentStationImages[indexPath.row].imageIndex   // get index of image in the main array (DB)
            let image = images[Int(index)]
            context.delete(image)                                        // Delete image from DB
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                images = try context.fetch(SavedImage.fetchRequest())
            } catch {
                print("Fetching Failed")
            }
        }
        
        // Reload table data after deleting
        tableView.reloadData()
    }
    
    
    
    // If user touvh 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // navigate to the image viewer page
        let viewer:ImageViewer = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewer") as! ImageViewer
    
        viewer.imageTitle = currentStationImages[indexPath.row].name        // Image name
        viewer.stationID = currentStationImages[indexPath.row].stationID    // Image station ID
        
        self.present(viewer, animated: false, completion: nil)
        
        
    }
    

    
    
}
