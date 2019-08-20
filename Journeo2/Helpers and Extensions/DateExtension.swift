//
//  DateExtension.swift
//  Journeo2
//
//  Created by Colin Smith on 8/15/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter.string(from: self)
    }
}
