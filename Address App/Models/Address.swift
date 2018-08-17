//
//  Address.swift
//  Address App
//
//  Created by Mazen on 8/14/18.
//  Copyright © 2018 Mazen. All rights reserved.
//

import UIKit
import CoreLocation

class Address: NSObject {
    
    var name : String? = ""
    var latitude : CLLocationDegrees = 0.0
    var longitude : CLLocationDegrees = 0.0
    var addressDesciption : String? = ""
    
    init( name : String? , lat : CLLocationDegrees , long : CLLocationDegrees , desc : String? )
    {
        self.name = name
        self.latitude = lat
        self.longitude = long
        self.addressDesciption = desc
        
        super.init()
    }

}
