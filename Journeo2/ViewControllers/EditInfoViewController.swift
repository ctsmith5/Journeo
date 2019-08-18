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

    @IBOutlet weak var changeDatePicker: UIDatePicker!
    @IBOutlet weak var changeLocationMapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func resetDateButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBOutlet weak var resetLocationButtonPressed: UIStackView!
    

    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
