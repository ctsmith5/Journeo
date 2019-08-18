//
//  EditEntryViewController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/14/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import CloudKit
class EditEntryViewController: UIViewController {

    var photos: [UIImage] = []
    var captions: [String?] = []
    
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
        photosCollectionView.dataSource = self
    }
    
    func selectPhotoButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Upload Image", message: "Select a photo", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true , completion: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    //MARK: - IBActions
    
    @IBAction func addNewPhotoButtonPressed(_ sender: UIButton) {
        selectPhotoButton()
    }
    
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if entry == nil {
            guard let titleText = titleTextField.text,
                let bodyText = bodyTextView.text else {return}
            let newEntry = Entry(title: titleText, body: bodyText)
            CloudKitController.shared.createEntry(entry: newEntry) { (success) in
                if success {
                    print("success from the CreateEntry Completion Block")
                    DispatchQueue.main.async {
                        self.tabBarController?.selectedIndex = 0
                    }
                }
                else {
                    
                }
            }
            
            var photosToSave: [Photo] = []
            
            for i in 0..<photos.count {
                let newPhoto = Photo(entryReference: CKRecord.Reference(recordID: newEntry.recordID, action: .deleteSelf), caption: captions[i], index: i, recordID: CKRecord.ID(recordName: UUID().uuidString), photograph: self.photos[i])
                photosToSave.append(newPhoto)
            }
            
            let records = photosToSave.compactMap({CKRecord(photo: $0)})
            
            CloudKitController.shared.saveManyPhotos(records: records) { (success) in
                if success {
                    print("success from the saving many photos block")
                }else {
                    print("failure to save photos")
                }
            }
            
        } // The if Statement that checks if this is a new Entry or not.
        else {
            // Set up a CKModifyRecords operation that takes in the entry and updates the necessary fields
            guard let titleText = titleTextField.text,
                  let bodyText = bodyTextView.text else {return}
            
            guard let entry = entry else {return}
            
            entry.title = titleText
            entry.body = bodyText
            
            CloudKitController.shared.updateEntry(entry: entry) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tabBarController?.selectedIndex = 0
                    }
                }else {
                    
                }
            }
        }
    }
    
    
    func updateUI() {
        guard let entry = entry else {return}
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
        //fetch photos and put them in the collection view somehow
        loadPhotos()
        
    }
    
    func loadPhotos() {
        guard let entry = entry else {return}
        CloudKitController.shared.fetchPhotos(entry: entry) { (photos) in
            var images: [UIImage] = []
            for image in photos {
                guard let meat = image.photograph else {return}
                images.append(meat)
            }
            self.photos = images
            DispatchQueue.main.async {
                self.photosCollectionView.reloadData()
            }
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
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addPhotoCell", for: indexPath) as! EntryPhotoCollectionViewCell
        let each = self.photos[indexPath.item]
        cell.entryPhotoImageView.image = each
        return cell
    }
}

extension EditEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.photos.append(photo)
            
            let captionAlert = UIAlertController(title: "Add a Caption?", message: nil, preferredStyle: .alert)
            captionAlert.addTextField { (textField) in
                textField.placeholder = "Enter a caption here..."
            }
            let addAction = UIAlertAction(title: "Add", style: .default) { (addText) in
                guard let captionText = captionAlert.textFields?[0].text,
                !captionText.isEmpty
                else {
                    self.captions.append(nil)
                    
                    return}
                self.captions.append(captionText)
                
            }
            let cancelAction = UIAlertAction(title: "No Caption", style: .default) { (closeAction) in
                self.captions.append(nil)
            }
            
            captionAlert.addAction(cancelAction)
            captionAlert.addAction(addAction)
            
            self.present(captionAlert, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.photosCollectionView.reloadData()
            }
        }
    }
}
