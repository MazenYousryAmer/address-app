//
//  AddressData.swift
//  Address App
//
//  Created by Mazen on 8/17/18.
//  Copyright © 2018 Mazen. All rights reserved.
//

import UIKit

class AddressData: NSObject {
    
    //MARK: - variable
    static let sharedInstance = AddressData()
    private var arrLocations : [Address] = []
    
    //MARK: - initializer
    override private init()
    {
        print("this should be only called once ")
    }
    
    //MARK: - data helper methods
    func addLocation(address : Address)
    {
        self.arrLocations.append(address)
    }
    
    func retreiveLocationFromIndex(index : Int) -> Address
    {
        return self.arrLocations[index]
    }
    
    func getAllLocations() -> [Address]
    {
        return self.arrLocations
    }

}
