//
//  ImageCaptionController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/19/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import CloudKit

class ImageCaptionController {
    
    
    static let shared = ImageCaptionController()
    
    var photos: [UIImage] = []
    var captions: [String] = []
    var recordIDs: [CKRecord.ID] = []
    
    
}
