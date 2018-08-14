//
//  ViewController.swift
//  Address App
//
//  Created by Mazen on 8/12/18.
//  Copyright © 2018 Mazen. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController , GIDSignInUIDelegate {

    //MARK: - outlets
    @IBOutlet var btnGmailLogin: UIButton!
    
    //MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("git added")
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - actions
    @IBAction func btnGmailLoginPressed()
    {
        GIDSignIn.sharedInstance().signIn()
    }


}

