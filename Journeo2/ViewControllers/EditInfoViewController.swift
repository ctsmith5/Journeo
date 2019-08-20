//
//  EditInfoViewController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/18/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import MapKit

class EditInfoViewController: UIViewController {

    var newDate: Date?
    var newCoordinate: CLLocation?
    
    var entry: Entry?
    
    @IBOutlet weak var changeDatePicker: UIDatePicker!
    @IBOutlet weak var changeLocationMapView: MKMapView!
    
    var coordinate: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        synchronizeUI()
    }
    
    func setupMap() {
        guard let coordinate = coordinate else {return}
        changeLocationMapView.setCenter(coordinate.coordinate, animated: true)
        let span = MKCoordinateSpan(latitudeDelta: 0.750, longitudeDelta: 0.750)
        let region = MKCoordinateRegion(center: coordinate.coordinate, span: span)
        self.changeLocationMapView.setRegion(region, animated: true)

    }
    func synchronizeUI(){
        guard let entry = entry else {return}
        changeDatePicker.date = entry.timestamp
        changeLocationMapView.setCenter(entry.location.coordinate, animated: false)
    }
    
    @IBAction func resetDateButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBOutlet weak var resetLocationButtonPressed: UIStackView!
    

    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        newDate = changeDatePicker.date
        let newLocation = changeLocationMapView.centerCoordinate
        newCoordinate = CLLocation(latitude: newLocation.latitude, longitude: newLocation.longitude)
        
       guard let entryToSave = entry else {return}
        guard let date = newDate,
            let location = newCoordinate else {return}
        entryToSave.timestamp = date
        entryToSave.location = location
        
        CloudKitController.shared.updateEntry(entry: entryToSave) { (success) in
            if success {
                print("success updating an entry's time and location")
            }else {
                print("not successfull updating entry's time and location")
            }
        }
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}


extension EditInfoViewController: MKMapViewDelegate {
    
}
