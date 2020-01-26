//
//  Entry.swift
//  Journeo2
//
//  Created by Colin Smith on 8/14/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation
import CoreLocation
import CloudKit

class Entry {
    
    var title: String
    // photodata
    
    var body: String
    var timestamp: Date
    var location: CLLocation
    //image
    
    let recordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), location: CLLocation = CLLocation(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.location = location
        self.recordID = recordID
    }
    
    init?(record: CKRecord) {
        guard let title = record[EntryConstants.titleKey] as? String,
            let body = record[EntryConstants.bodyKey] as? String,
            let timestamp = record[EntryConstants.timestampKey] as? Date,
            let location = record[EntryConstants.locationKey] as? CLLocation
            else { return nil }
        
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.location = location
        self.recordID = record.recordID
    }
}//End of Entry Class

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

extension Entry: SearchableEntry {
    func bodyMatches(searchTerm: String) -> Bool {
        return body.localizedCaseInsensitiveContains(searchTerm)
    }
    func titleMatches(searchTerm: String) -> Bool {
        return title.localizedCaseInsensitiveContains(searchTerm)
    }
    
    
}

protocol EntrySelectionDelegate {
    func entrySelected(_ newEntry: Entry)
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.typeKey, recordID: entry.recordID)
        self.setValue(entry.title, forKey: EntryConstants.titleKey)
        self.setValue(entry.body, forKey: EntryConstants.bodyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.timestampKey)
        self.setValue(entry.location, forKey: EntryConstants.locationKey)
    }
}

struct EntryConstants {
    static let typeKey = "Entry"
    static let titleKey = "Title"
    static let bodyKey = "Body"
    static let timestampKey = "Timestamp"
    static let locationKey = "Location"
}

