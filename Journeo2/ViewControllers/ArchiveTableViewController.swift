//
//  ArchiveTableViewController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/14/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import MapKit

class ArchiveTableViewController: UITableViewController {

    
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var filterOptionsStackView: UIStackView!
    @IBOutlet weak var monthPickerView: MonthPickerView!
    @IBOutlet weak var yearPickerView: YearPickerView!
    @IBOutlet weak var pickerStackView: UIStackView!
    @IBOutlet weak var filterMapView: MKMapView!
    
    var filterViewPosition: Int = 1 {
        didSet {
         //checkViewHeight()
        }
    }
    
    var entries: [Entry] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func checkViewHeight() {
        filterContainerView.translatesAutoresizingMaskIntoConstraints = false
        if filterViewPosition == 1 {
            filterOptionsStackView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
            filterOptionsStackView.widthAnchor.constraint(equalTo: filterContainerView.widthAnchor, multiplier: 1).isActive = true
            
        }
        if filterViewPosition == 2 {
            filterOptionsStackView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
            filterOptionsStackView.widthAnchor.constraint(equalTo: filterContainerView.widthAnchor, multiplier: 1).isActive = true
        }
        if filterViewPosition == 3 {
            filterOptionsStackView.heightAnchor.constraint(equalToConstant: 400.0).isActive = true
            filterOptionsStackView.widthAnchor.constraint(equalTo: filterContainerView.widthAnchor, multiplier: 1).isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterOptionsStackView.removeArrangedSubview(pickerStackView)
        filterOptionsStackView.removeArrangedSubview(filterMapView)
    }

    override func viewWillAppear(_ animated: Bool) {
        CloudKitController.shared.fetchEntries { (entries) in
            self.entries = entries
        }
    }
    
    
    @IBAction func showOptionsButtonPressed(_ sender: UIButton) {
        if filterViewPosition == 1 {
            //the search bar is visable
            //show the pickers
            
            filterOptionsStackView.addArrangedSubview(pickerStackView)
            filterViewPosition += 1
            return
        }
        if filterViewPosition == 2 {
            //the pickers are visable
            //show the map
            filterOptionsStackView.addArrangedSubview(filterMapView)
            filterViewPosition += 1
            return
        }
        if filterViewPosition == 3 {
            //all are visble
            //don't do anything - this button should not even be visible
            return
        }
        
    }
    
    @IBAction func hideOptionsButtonPressed(_ sender: UIButton) {
        if filterViewPosition == 1 {
            //only the searchbar is visable
            //Don't do anything - the button shouldn't even be visible
            return
        }
        if filterViewPosition == 2 {
            //the picker is visable
            //take away the picker
            filterOptionsStackView.removeArrangedSubview(pickerStackView)
            filterViewPosition -= 1
            return
        }
        if filterViewPosition == 3 {
            //the map is visible
            //take away the map
            filterOptionsStackView.removeArrangedSubview(filterMapView)
            filterViewPosition -= 1
        }
        
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCell", for: indexPath) as? ArchiveTableViewCell else {return UITableViewCell()}
        
        cell.titleLabel.text = self.entries[indexPath.row].title
        cell.dateLabel.text = self.entries[indexPath.row].timestamp.formatDate()
        cell.localeLabel.text = "Locale"
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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
        
        if segue.identifier == "toEditEntryView" {
            guard let destinationVC = segue.destination as? EditEntryViewController else {return}
            guard let selected = tableView.indexPathForSelectedRow else {return}
            let chosen = self.entries[selected.row]
            destinationVC.entry = chosen
        }
    }
}
