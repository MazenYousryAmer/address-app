//
//  MapViewController.swift
//  Address App
//
//  Created by Mazen on 8/14/18.
//  Copyright © 2018 Mazen. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController , GMSMapViewDelegate{
    
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
        
//        let camera = GMSCameraPosition.camera(withLatitude: 30.0, longitude: 30.0, zoom: 6.0)
//        self.mapView = GMSMapView.map(withFrame: CGRect(x: 0.0, y: 0.0, width: self.mapView.frame.width, height: self.mapView.frame.height), camera: camera)
        self.mapView.delegate = self
        self.mapView.mapType = .normal
        mapView.settings.myLocationButton = true
//        self.view.addSubview(<#T##view: UIView##UIView#>)
        
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2D(latitude: 30.0, longitude: 30.0)
        //        marker.title = "cairo"
        //        marker.snippet = "masr"
        //        marker.map = self.mapView
        
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // test data
        let testAddress = Address(name: "test name test name test name test name", lat: 31.0, long: 30.0, desc: "test address description test address description test address description test address description test address description test address description")
        
        let testAddress2 = Address(name: "test name2", lat: 30.5, long: 30.5, desc: "test address description2")
        
        AddressData.sharedInstance.addLocation(address: testAddress)
        AddressData.sharedInstance.addLocation(address: testAddress2)
        
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
    
//    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        reverseGeocodeCoordinate(position.target)
//    }
    
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

extension MapViewController : showLocation
{
    func showPinWithLocation(lat: Double, long: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 12.0)
        self.mapView.camera = camera
    }
}
