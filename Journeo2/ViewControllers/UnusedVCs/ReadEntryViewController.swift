//
//  ReadEntryViewController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/14/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class ReadEntryViewController: UIViewController {

    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var readBodyTextLabel: UILabel!
    
    
    var entry: Entry?{
        didSet{
            loadViewIfNeeded()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        guard let entry = entry else {return}
        titleTextLabel.text = entry.title
        readBodyTextLabel.text = entry.body
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditEntryView" {
            guard let destinationVC = segue.destination as? ReadEntryViewController else {return}
            destinationVC.entry = self.entry
        }
    }
}
