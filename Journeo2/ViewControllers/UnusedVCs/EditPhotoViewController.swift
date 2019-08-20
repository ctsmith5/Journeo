//
//  EditPhotoViewController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/17/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class EditPhotoViewController: UIViewController {

    var newText: String? = nil
    var index: Int? = nil
    
    var photo: UIImage = UIImage() {
        didSet{
            loadViewIfNeeded()
            updateUI()
        }
    }
    var caption: String? {
        didSet{
            loadViewIfNeeded()
            updateUI()
        }
    }
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let newText = newText,
              let index = index else {return}
    }
    
    func updateUI(){
        captionTextField?.text = caption
        photoImageView.image = photo
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
   
}


