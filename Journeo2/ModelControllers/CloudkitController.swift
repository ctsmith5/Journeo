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
    
    var entries: [Entry] = []
    
    
    func fetchEntries(completion: @escaping ([Entry]) -> Void){
        //Just fetch all the entries for a user's private cloud database
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.typeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print("\(error.localizedDescription)\(error) in function: \(#function)")
                completion([])
                return
            }
            
            guard let records = records else {return}
            let entries = records.compactMap({Entry(record: $0)})
            self.entries = entries
            completion(entries)
        }
    }
    
    
    func createEntry(entry: Entry, completion: @escaping (Bool) -> Void){
        //here we take it a new entry and create a new record with it.
        
        //create new record
        let record = CKRecord(entry: entry)
        
        //database save method
        
        privateDB.save(record) { (record, error) in
            
            if let error = error {
                print("\(error.localizedDescription)\(error) in function: \(#function)")
                completion(false)
                return
            }
            print("saved a record")
            completion(true)
            
        }
        
        
    }
    
    func updateEntry(entry: Entry, completion: @escaping (Bool) -> Void){
        //here we take in a previously existing entry and update it's record
    
        
        //Initialize the class that will modify a post's CKRecord in CloudKit
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [CKRecord(entry: entry)], recordIDsToDelete: nil)
        //Only updates the properties that have changed on the post
        modifyOperation.savePolicy = .changedKeys
        //This is the completion block that will be called after the modify operation finishes
        modifyOperation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }else {
                completion(true)
            }
        }
        //Add the operation to the public database
        privateDB.add(modifyOperation)
        
    }
    
    
    func  fetchPhotos(entry: Entry, completion: @escaping ([Photo]) -> Void) {
        //perform query with a predicate of entry refrences that match the record ID of the entry that was passed in
        let entryReference = entry.recordID
        let predicate = NSPredicate(format: "%K == %@", PhotoConstants.referenceKey, entryReference)
        let query = CKQuery(recordType: PhotoConstants.typeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print("\(error.localizedDescription)\(error) in function: \(#function)")
                completion([])
                return
            }
            
            guard let records = records else {return}
            var photosDecoded: [Photo] = []
            for record in records {
                guard let photo = Photo(ckRecord: record) else {print("problem converting record") ; return}
                photosDecoded.append(photo)
            }
            completion(photosDecoded)
        }
    }
    
    func addPhoto(entry: Entry, completion: @escaping (Bool) -> Void) {
        
    }
    
    func removePhoto(photoID: CKRecord.ID, completion: @escaping (Bool) -> Void) {
        
        privateDB.delete(withRecordID: photoID) { (recordToDelete, error) in
            if let error = error {
                print("\(error.localizedDescription)\(error) in function: \(#function)")
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    
    func saveManyPhotos(records: [CKRecord], completion: @escaping (Bool) -> Void ) {
     
        let saveOperation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        saveOperation.savePolicy = .changedKeys
        
        saveOperation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }else {
                completion(true)
            }
        }
        CKContainer.default().privateCloudDatabase.add(saveOperation)
    }
}
