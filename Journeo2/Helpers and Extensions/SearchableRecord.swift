//
//  SearchableRecord.swift
//  Journeo2
//
//  Created by Colin Smith on 8/20/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation

protocol SearchableEntry {
    func bodyMatches(searchTerm: String) -> Bool
    func titleMatches(searchTerm: String) -> Bool
}

protocol SearchableCaption {
    func captionMatches(searchTerm: String) -> Bool
}

protocol SearchableLocation {
    func locationMatches(searchTerm: String) -> Bool
}

protocol SearchableDate {
    func dateMatches(searchTerm: String) -> Bool
}
