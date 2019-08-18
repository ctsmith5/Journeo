//
//  Photo.swift
//  Journeo2
//
//  Created by Colin Smith on 8/14/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import CloudKit

class Photo {
    
    var photoData: Data?
    var caption: String?
    let entryReference: CKRecord.Reference
    let index: Int
    let recordID: CKRecord.ID
    var imageAsset: CKAsset? {
        get{
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(recordID.recordName).appendingPathExtension("jpg")
            do{
                try photoData?.write(to: fileURL)
            }catch{
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    var photograph: UIImage? {
        get{
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set{
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(entryReference: CKRecord.Reference, caption: String?, index: Int, recordID: CKRecord.ID, photograph: UIImage) {
        self.entryReference = entryReference
        self.caption = caption
        self.index = index
        self.recordID = recordID
        self.photograph = photograph
    }
    
    init?(ckRecord: CKRecord) {
        do{
            
            guard let caption = ckRecord[PhotoConstants.captionKey] as? String? else {print("failing the caption") ; return nil}
            guard let reference = ckRecord[PhotoConstants.referenceKey] as? CKRecord.Reference else {print("failing the EntryReference") ; return nil}
            guard let photoAsset = ckRecord[PhotoConstants.photographKey] as? CKAsset else {print("failing the ckAsset") ; return nil}
            
            //FIXME: - We found the record converting problem
            guard let index = ckRecord[PhotoConstants.indexKey] as? Int else {print("failing the int") ; return nil}
        
            let photoData = try Data(contentsOf: photoAsset.fileURL!)
            
            self.caption = caption
            self.entryReference = reference
            self.photoData = photoData
            self.recordID = ckRecord.recordID
            self.index = index
        }catch {
            print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
            return nil
        }
    }
} // End of Photo Class

extension CKRecord {
    convenience init(photo: Photo){
        self.init(recordType: PhotoConstants.typeKey, recordID: photo.recordID)
        self.setValue(photo.caption, forKey: PhotoConstants.captionKey)
        self.setValue(photo.entryReference, forKey: PhotoConstants.referenceKey)
        self.setValue(photo.imageAsset, forKey: PhotoConstants.photographKey)
        self.setValue(photo.index, forKey: PhotoConstants.indexKey)
    }
}


struct PhotoConstants {
    static let typeKey = "Photo"
    static let captionKey = "Caption"
    static let photographKey = "Photograph"
    static let referenceKey = "EntryReference"
    static let indexKey = "Index"
}
