//
//  DetailsViewController.swift
//  Address App
//
//  Created by Mazen on 8/15/18.
//  Copyright © 2018 Mazen. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    //MARK: - iboutlets
    @IBOutlet var pinsTable : UITableView!
    var delegate: showLocation!
    
    //MARK: - variables
//    var arrPins : [Address] = []
    
    //MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddressData.sharedInstance.getAllLocations().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell") as! DetailsTableViewCell
//        let pinObject = self.arrPins[indexPath.row]
        let pinObject = AddressData.sharedInstance.retreiveLocationFromIndex(index: indexPath.row)
        cell.lblAddress.text = pinObject.name
        cell.lblAddressDesciption.text = pinObject.addressDesciption
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell") as! DetailsTableViewCell
        let pinObject = AddressData.sharedInstance.retreiveLocationFromIndex(index: indexPath.row)
        cell.lblAddress.text = pinObject.name
        cell.lblAddressDesciption.text = pinObject.addressDesciption
        
        cell.lblAddress.sizeToFit()
        cell.lblAddressDesciption.sizeToFit()
        return cell.lblAddress.frame.height + cell.lblAddressDesciption.frame.height + 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pin = AddressData.sharedInstance.retreiveLocationFromIndex(index: indexPath.row)
        print("lat : \(pin.latitude) and long : \(pin.longitude)")
        self.delegate.showPinWithLocation(lat: pin.latitude, long: pin.longitude)
        self.navigationController?.popViewController(animated: true)
        // go to x,y on map
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
