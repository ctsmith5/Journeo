//
//  PhotosTableViewController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/17/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class PhotosTableViewController: UITableViewController {

    
    var photos: [UIImage] = []{
        didSet{
            loadViewIfNeeded()
        }
    }
    var captions: [String] = []{
        didSet{
            loadViewIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(photos.count)
        print(captions.count)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return photos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PhotosTableViewCell else {return UITableViewCell()}

        cell.photoImageView.image = photos[indexPath.row]
        cell.captionLabel.text = captions[indexPath.row]
        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
 

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIndividualView" {
            let destinationVC = segue.destination as? EditPhotoViewController
            guard let index = tableView.indexPathForSelectedRow else {return}
            
            destinationVC?.photo = photos[index.row]
            destinationVC?.caption = captions[index.row]
            
        }
    }
    

}
