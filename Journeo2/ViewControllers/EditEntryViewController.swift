//
//  EditEntryViewController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/14/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation

class EditEntryViewController: UIViewController {


    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: EditEntryTextView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var loadPhotosActivity: UIActivityIndicatorView!
    
    
    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateUI()
        }
    }
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        checkLocationAuthorization()
        checkLocationServices()
        getLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        photosCollectionView.reloadData()
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
            let newEntry = Entry(title: titleText, body: bodyText, location: currentLocation)
            CloudKitController.shared.createEntry(entry: newEntry) { (success) in
                if success {
                    
                    print("success from the CreateEntry Completion Block")
                    let successAlert = UIAlertController(title: "Success", message: "iCloud has registered your changes. Wait a few seconds for synchronization before reloading.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    successAlert.addAction(okAction)
                    self.present(successAlert, animated: true, completion: nil)
                }
                else {
                    print("problem saving new entry to cloudkit")
                }
            }
            
            var photosToSave: [Photo] = []
            
            for i in 0..<ImageCaptionController.shared.photos.count {
                let newPhoto = Photo(entryReference: CKRecord.Reference(recordID: newEntry.recordID, action: .deleteSelf), caption: ImageCaptionController.shared.captions[i], index: i, recordID: CKRecord.ID(recordName: UUID().uuidString), photograph: ImageCaptionController.shared.photos[i])
                photosToSave.append(newPhoto)
            }
            
            //if we can filter out records already on cloudkit we can prevent them from being saved in the saveManyPhotosFunction.
            let records = photosToSave.compactMap {CKRecord(photo: $0)}
            
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
            
            var photosToSave: [Photo] = []
            
            for i in 0..<ImageCaptionController.shared.photos.count {
                let newPhoto = Photo(entryReference: CKRecord.Reference(recordID: entry.recordID, action: .deleteSelf), caption: ImageCaptionController.shared.captions[i], index: i, recordID: ImageCaptionController.shared.recordIDs[i], photograph: ImageCaptionController.shared.photos[i])
                photosToSave.append(newPhoto)
            }
            
           
            let records = photosToSave.compactMap { CKRecord(photo: $0) }
            
            CloudKitController.shared.saveManyPhotos(records: records) { (success) in
                if success {
                    print("success from the saving many photos block")
                    
                }else {
                    print("failure to save photos")
                }
            }
            
            CloudKitController.shared.updateEntry(entry: entry) { (success) in
                if success {
                    DispatchQueue.main.async {
                        let successAlert = UIAlertController(title: "Saved", message: "iCloud has registered your changes. Wait a few seconds for synchronization before reloading.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        successAlert.addAction(okAction)
                        self.present(successAlert, animated: true, completion: nil)
                    }
                }else {
                    
                }
            }
        }
    }
    
    
    func updateUI() {
        guard let entry = entry else {return}
        
        DispatchQueue.main.async {
            self.loadViewIfNeeded()
            self.titleTextField.text = entry.title
            self.bodyTextView.text = entry.body
        }
        
        //fetch photos and put them in the collection view somehow
        loadPhotos()
    }
    
    func loadPhotos() {
        guard let entry = entry else {return}
        loadPhotosActivity.startAnimating()
        CloudKitController.shared.fetchPhotos(entry: entry) { (photos) in
            var images: [UIImage] = []
            var strings: [String] = []
            var identifiers: [CKRecord.ID] = []
            for image in photos {
                guard let meat = image.photograph else {return}
                      let potatoes = image.caption
                       let salad = image.recordID
                images.append(meat)
                strings.append(potatoes)
                identifiers.append(salad)
                
            }
            ImageCaptionController.shared.photos = images
            ImageCaptionController.shared.captions = strings
            ImageCaptionController.shared.recordIDs = identifiers
           
            DispatchQueue.main.async {
                self.photosCollectionView.reloadData()
                self.loadPhotosActivity.stopAnimating()
            }
        }
    }

    //MARK: - Mapkit Methods
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            // Best Case
            break
        case .authorizedAlways:
            break
        case .denied:
            // Show Alert to help them back to permissions
            locationManager.requestWhenInUseAuthorization()
            break
        case .notDetermined:
            
            break
        case .restricted:
            break
        default :
            //I dunno
            break
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        }else{
            // Ask for location again
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotosTVC"{
            //guard let destinationVC = segue.destination as? PhotosTableViewController else {return}
            

        }
        if segue.identifier == "toEditPanel" {
            let destination = segue.destination as? EditInfoViewController
            destination?.coordinate = currentLocation
            guard let currentEntry = self.entry else {return}
            guard let title = titleTextField.text,
                let body = bodyTextView.text else {return}
            currentEntry.title = title
            currentEntry.body = body
            destination?.entry = currentEntry
        }
    }
}

//MARK: - Extensions
extension EditEntryViewController: CLLocationManagerDelegate{
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    func getLocation(){
        if entry == nil {
            locationManager.startUpdatingLocation()
        }else {
            guard let entry = entry else {return}
            currentLocation = entry.location
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let currentLocation = locations.first else {return}
        self.currentLocation = currentLocation
    }
}

extension EditEntryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Collection View Datasource Methods
    //This will be for the photo collection view. When the entry is set, the load photo method runs which fetches the photos associated with that entry
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageCaptionController.shared.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addPhotoCell", for: indexPath) as! EntryPhotoCollectionViewCell
        let each = ImageCaptionController.shared.photos[indexPath.item]
        cell.entryPhotoImageView.image = each
        return cell
    }
}

extension EditEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            ImageCaptionController.shared.photos.append(photo)
            ImageCaptionController.shared.recordIDs.append(CKRecord.ID(recordName: UUID().uuidString))
            
            let captionAlert = UIAlertController(title: "Add a Caption?", message: nil, preferredStyle: .alert)
            captionAlert.addTextField { (textField) in
                textField.placeholder = "Enter a caption here..."
            }
            let addAction = UIAlertAction(title: "Add", style: .default) { (addText) in
                guard let captionText = captionAlert.textFields?[0].text,
                !captionText.isEmpty
                else {
                   ImageCaptionController.shared.captions.append("")
                    return}
                ImageCaptionController.shared.captions.append(captionText)
                
            }
            let cancelAction = UIAlertAction(title: "No Caption", style: .default) { (closeAction) in
               ImageCaptionController.shared.captions.append("")
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

extension EditEntryViewController: EntrySelectionDelegate {
    func entrySelected(_ newEntry: Entry) {
        self.entry = newEntry
    }
}
