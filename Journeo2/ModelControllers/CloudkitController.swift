//
//  CloudkitController.swift
//  Journeo2
//
//  Created by Colin Smith on 8/14/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import CloudKit

class CloudKitController {
    
    let privateDB = CKContainer.default().privateCloudDatabase
    static let shared = CloudKitController()
    
    
    
    
    func createEntry(entry: Entry, completion: @escaping (Bool) -> Void){
        //here we take it a new entry and create a new record with it.
        
        //create new record
        
        //database save method
        
        
    }
    
    
    
    func updateEntry(entry: Entry, completion: @escaping (Bool) -> Void){
        //here we take in a previously existing entry and update it's record
        
        //CKModifyrecords operation
        
    }
    
    
    func fetchPhotos(entry: Entry, completion: @escaping ([Photo]) -> Void) {
        //perform query with a predicate of entry refrences that match the record ID of the entry that was passed in
        let entryReference = entry.recordID
        let predicate = NSPredicate(format: "%K == %@", PhotoConstants.referenceKey, entryReference)
        let query = CKQuery(recordType: PhotoConstants.typeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            
            
            guard let records = records else {return}
            let photos = records.compactMap({Photo(ckRecord: $0)})
            completion(photos)
        }
    }
    
    func addPhoto(entry: Entry, completion: @escaping (Bool) -> Void) {
        
    }
    
    func removePhoto(entry: Entry, completion: @escaping (Bool) -> Void) {
        
    }
    
    
    
    
}
