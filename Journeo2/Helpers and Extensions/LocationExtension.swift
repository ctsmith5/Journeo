//
//  LocationExtension.swift
//  Journeo2
//
//  Created by Colin Smith on 8/19/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    func localeString() -> String {
        
         var returnString: String?
        
        geocode(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude) { (point, error) in
            if let error = error {
                print("\(error.localizedDescription)\(error) in function: \(#function)")
                return
            }
            guard let point = point else {return}
            
            guard let city =  point[0].locality else {return}
            
            returnString = city
           
        }
        guard let finalString = returnString else {return ""}
        print(finalString)
        return finalString
    }// End of LocaleString Function
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), completionHandler: completion)

    }
}
