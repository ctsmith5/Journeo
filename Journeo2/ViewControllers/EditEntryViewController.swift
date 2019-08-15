//
//  EditEntryViewController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/14/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class EditEntryViewController: UIViewController {

    var photos: [Photo] = []
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: EditEntryTextView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    
    
    
    
    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateUI()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosCollectionView.delegate = self

    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if entry == nil {
            guard let titleText = titleTextField.text,
                let bodyText = bodyTextView.text else {return}
            
            //Still need to figure out how to upload the photos.
            
            let newEntry = Entry(title: titleText, body: bodyText)
            CloudKitController.shared.createEntry(entry: newEntry) { (success) in
                if success {
                    
                }
                else {
                    
                    
                }
            }
        } // The if Statement that checks if this is a new Entry or not.
        else {
            // Set up a CKModifyRecords operation that takes in the entry and updates the necessary fields
            
        }
    }
    
    
    func updateUI() {
        guard let entry = entry else {return}
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
        //fetch photos and put them in the collection view somehow
        
        
    }
    
    func loadPhotos() {
        guard let entry = entry else {return}
        CloudKitController.shared.fetchPhotos(entry: entry) { (photos) in
            self.photos = photos
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // going to need to handle navigation over to the photosViewController
        
        
    }


}


extension EditEntryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Collection View Datasource Methods
    //This will be for the photo collection view. When the entry is set, the load photo method runs which fetches the photos associated with that entry
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! EntryPhotoCollectionViewCell
        
        let each = self.photos[indexPath.item]
        
        cell.entryPhotoImageView.image = each.photograph
        
        return cell
    }
    
    
    
}
