//
//  MapViewController.swift
//  Address App
//
//  Created by Mazen on 8/14/18.
//  Copyright © 2018 Mazen. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapViewController: UIViewController , GMSMapViewDelegate {
    
    // MARK: - iboutlet
    @IBOutlet var mapView : GMSMapView!
    
    //MARK: - variable
    var infoMarker = GMSMarker()
    var locationManager = CLLocationManager()
//    var arrLocations : [Address] = []
    var selectedPinAddress : GMSAddress!
    
    
    // MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        self.mapView.mapType = .normal
        mapView.settings.myLocationButton = true

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
//        // test data
//        let testAddress = Address(name: "test name test name test name test name", lat: 31.0, long: 30.0, desc: "test address description test address description test address description test address description test address description test address description")
//        
//        let testAddress2 = Address(name: "test name2", lat: 30.5, long: 30.5, desc: "test address description2")
//        
//        AddressData.sharedInstance.addLocation(address: testAddress)
//        AddressData.sharedInstance.addLocation(address: testAddress2)
        
        self.refreshPins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - map delegate
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D)
    {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        infoMarker.snippet = placeID
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        self.refreshPins() // clearing Pin before adding new
        let marker = GMSMarker(position: coordinate)
        marker.map = self.mapView
        reverseGeocodeCoordinate(coordinate)
    }
    
    func refreshPins()
    {
        // reset
        self.mapView.clear()
        self.selectedPinAddress = nil
        
        for address in AddressData.sharedInstance.getAllLocations()
        {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
            marker.title = address.name
            //        marker.snippet = "masr"
            marker.map = self.mapView
        }
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let _ = address.lines else {
                return
            }
            
            print(address)
            self.selectedPinAddress = address
            
        }
    }
    
    //MARK: - actions
    @IBAction func saveBtnPressed()
    {
        guard self.selectedPinAddress != nil else {
            return
        }
        
        let addressToBeSaved  = Address(name: ((self.selectedPinAddress.lines?[0])! + " " + (self.selectedPinAddress.lines?[1])!) , lat: selectedPinAddress.coordinate.latitude, long: selectedPinAddress.coordinate.longitude, desc: selectedPinAddress.administrativeArea)
        AddressData.sharedInstance.addLocation(address: addressToBeSaved)
        self.refreshPins()
    }
    
    // The code snippet below shows how to create and display a GMSPlacePickerViewController.
    @IBAction func pickPlaceBtnPressed() {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autoCompleteBtnPressed() {
        let autocompleteController = GMSAutocompleteViewController()
        
        let filter = GMSAutocompleteFilter()
        filter.country = "EG"
        autocompleteController.autocompleteFilter = filter
        
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func editBtnPressed()
    {
        self.performSegue(withIdentifier: "DetailsViewController", sender: nil)
    }
    
    @IBAction func logoutBtnPressed()
    {
        deleteUserToken()
        
        let loginVC = self.storyboard?.instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
    }

    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "DetailsViewController"
        {
            if let detailsVC = segue.destination as? DetailsViewController
            {
                detailsVC.delegate = self
            }
        }
     }
    
}

//MARK: - location delegate
extension MapViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
    }
}

//MARK: - map location delegate
extension MapViewController : showLocation
{
    func showPinWithLocation(lat : Double , long : Double , zoom : Float) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: zoom)
        self.mapView.camera = camera
    }
}

//MARK: - places delegate
extension MapViewController : GMSPlacePickerViewControllerDelegate
{
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(String(describing: place.formattedAddress))")
        print("Place attributions \(String(describing: place.attributions))")
        self.showPinWithLocation(lat: place.coordinate.latitude, long: place.coordinate.longitude, zoom: 12.0)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
}

//MARK: - auto complete delegate
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        for addresComponent in place.addressComponents!
        {
            print(addresComponent)
        }
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("place cordinates: \(place.coordinate)")
        self.showPinWithLocation(lat: place.coordinate.latitude, long: place.coordinate.longitude , zoom: 18.0)
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // error handeling
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
