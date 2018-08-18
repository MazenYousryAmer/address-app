//
//  File.swift
//  Address App
//
//  Created by Mazen on 8/18/18.
//  Copyright © 2018 Mazen. All rights reserved.
//

import Foundation

func saveUserToken(userToken : String)
{
    UserDefaults.standard.set(userToken, forKey: "token")
}

func deleteUserToken()
{
    UserDefaults.standard.set("", forKey: "token")
}

func IsUserTokenExisting() -> Bool
{
    var isTokenAvailable = false
    if UserDefaults.standard.value(forKey: "token") as? String != "" && UserDefaults.standard.value(forKey: "token") as? String != nil
    {
        isTokenAvailable = true
    }
    return isTokenAvailable
}
