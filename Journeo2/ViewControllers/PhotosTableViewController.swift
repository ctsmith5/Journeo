//
//  PhotosTableViewController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/17/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class PhotosTableViewController: UITableViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ImageCaptionController.shared.photos.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentActionSheet(index: indexPath.row)
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PhotosTableViewCell else {return UITableViewCell()}
        
        cell.photoImageView.image = ImageCaptionController.shared.photos[indexPath.row]
        cell.captionLabel.text = ImageCaptionController.shared.captions[indexPath.row]
        return cell
    }


    func presentActionSheet(index: Int) {
        let updateAlert = UIAlertController(title: "Update Photo", message: "Select an Action", preferredStyle: .actionSheet)
        let updateCaptionAction = UIAlertAction(title: "Update Caption", style: .default) { (updateCaption) in
           self.presentCommentUpdate(index: index)
        }
        let deletePhotoAction = UIAlertAction(title: "Delete Photo", style: .destructive) { (delete) in
            let confirmationAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to remove this photo?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (yes) in
                CloudKitController.shared.removePhoto(photoID: ImageCaptionController.shared.recordIDs[index] , completion: { (success) in
                    DispatchQueue.main.async {
                        ImageCaptionController.shared.photos.remove(at: index)
                        ImageCaptionController.shared.captions.remove(at: index)
                        ImageCaptionController.shared.recordIDs.remove(at: index)
                        self.tableView.reloadData()
                    }
                })
            })
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            confirmationAlert.addAction(yesAction)
            confirmationAlert.addAction(noAction)
            
            self.present(confirmationAlert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        updateAlert.addAction(updateCaptionAction)
        updateAlert.addAction(deletePhotoAction)
        updateAlert.addAction(cancelAction)
        
        present(updateAlert, animated: true, completion: nil)
        
    }
    func presentCommentUpdate(index: Int){
        let updateCommentAlert = UIAlertController(title: "Update", message: nil, preferredStyle: .alert)
        updateCommentAlert.addTextField { (textfield) in
            textfield.placeholder = "Enter Caption..."
        }
        let update = UIAlertAction(title: "Update", style: .default) { (update) in
            guard let newText = updateCommentAlert.textFields?[0].text else {return}
            ImageCaptionController.shared.captions.remove(at: index)
            ImageCaptionController.shared.captions.insert(newText, at: index)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        updateCommentAlert.addAction(update)
        updateCommentAlert.addAction(cancelAction)
        
        present(updateCommentAlert, animated: true, completion: nil)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
 */
}



