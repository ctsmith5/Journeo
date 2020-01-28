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
    
    
    var collapseDetailViewController = true

    var isSearching: Bool = false
    
    var resultsArray: [SearchableEntry] = []
    
    var dataSource: [SearchableEntry] {
        return isSearching ? resultsArray : self.entries
    }
    
    var delegate: EntrySelectionDelegate?
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.collapseDetailViewController = false
        let selected = entries[indexPath.row]
        self.delegate?.entrySelected(selected)
        if let detailViewController = delegate as? EditEntryViewController {
            splitViewController?.showDetailViewController(detailViewController.parent ?? UIViewController(), sender: nil)
        }
    }

    @IBAction func newEntryButtonPressed(_ sender: UIBarButtonItem) {
        // Present Alert to Confirm Switch
        
        // if Yes: They are happy with the state of their iCloud, set the current entry to nil and rock and roll
        if let detailViewController = delegate as? EditEntryViewController {
            let newEntry = Entry(title: "", body: "",location: detailViewController.currentLocation)
            delegate?.entrySelected(newEntry)
            splitViewController?.showDetailViewController(detailViewController.parent ?? UIViewController(), sender: nil)
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
        }
        if segue.identifier == "toEditEntryView" {
            guard let destinationVC = segue.destination as? EditEntryViewController else {return}
            guard let selected = tableView.indexPathForSelectedRow else {return}
            let chosen = self.entries[selected.row]
            destinationVC.entry = chosen
        }
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
