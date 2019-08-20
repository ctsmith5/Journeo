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
    @IBOutlet weak var archiveSearchBar: UISearchBar!
    
    
    
    let monthPickerDelegate = MonthPickerDelegate()
    let yearPickerDelegate = YearPickerDelegate()
    var isSearching: Bool = false
    
    var resultsArray: [SearchableEntry] = []
    
    var dataSource: [SearchableEntry] {
        return isSearching ? resultsArray : self.entries
    }
    
    
    
    var entries: [Entry] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func resetImageCaptionSOT(){
        ImageCaptionController.shared.photos = []
        ImageCaptionController.shared.captions = []
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
     archiveSearchBar.delegate = self
        
    }


    override func viewWillAppear(_ animated: Bool) {
        resetImageCaptionSOT()
        CloudKitController.shared.fetchEntries { (entries) in
            self.entries = entries
        }
    }
    
  
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCell", for: indexPath) as? ArchiveTableViewCell else {return UITableViewCell()}
        let entry = dataSource[indexPath.row] as? Entry
        cell.entry = entry
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


class MonthPickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let months = ["January","February","March", "April"]
        let month = months[row]
        return month
    }
    
}

class YearPickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let months = ["1990","1991","1992", "1993", "1994", "1995"]
        let month = months[row]
        return month
    }
    
}


extension ArchiveTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray = self.entries.filter {
            $0.titleMatches(searchTerm: searchText)
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = self.entries
        tableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
}
