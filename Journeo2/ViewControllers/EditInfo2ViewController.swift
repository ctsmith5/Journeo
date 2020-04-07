//
//  EditInfo2ViewController.swift
//  Journeo2
//
//  Created by Colin Smith on 3/1/20.
//  Copyright © 2020 Colin Smith. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class EditInfo2ViewController: UIViewController {
    var newDate: Date?
    var newCoordinate: CLLocation?
    var coordinate: CLLocation?
    var entry: Entry?
    @IBOutlet weak var changeLocationMapView: MKMapView!
    @IBOutlet weak var changeDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}
    
    
