//
//  UpdateCaptionTextField.swift
//  Journeo2
//
//  Created by Colin Smith on 8/19/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class UpdateCaptionTextField: UITextField {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        self.inputAccessoryView = toolbar
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @objc private func dismissKeyboard() {
        self.resignFirstResponder()
    }

}
