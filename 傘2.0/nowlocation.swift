//
//  File.swift
//  傘2.0
//
//  Created by chang on 2020/6/1.
//  Copyright © 2020 chang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class nowlocation: UIViewController, CLLocationManagerDelegate {

@IBOutlet weak var map: MKMapView!
var locationManager: CLLocationManager?

override func viewDidLoad() {
super.viewDidLoad()
locationManager = CLLocationManager()
locationManager?.requestWhenInUseAuthorization()
locationManager?.delegate = self
locationManager?.desiredAccuracy = kCLLocationAccuracyBest
locationManager?.activityType = .automotiveNavigation
locationManager?.startUpdatingLocation()



if let coordinate = locationManager?.location?.coordinate{
let xScale:CLLocationDegrees = 0.009
let yScale:CLLocationDegrees = 0.009
let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: yScale, longitudeDelta:xScale)
let region = MKCoordinateRegion(center: coordinate, span: span)
map.setRegion(region, animated: true)
}
map.userTrackingMode = .followWithHeading
}

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

print("_____________________________")
print(locations[0].coordinate.latitude)
print(locations[0].coordinate.longitude)
}

override func viewDidDisappear(_ animated: Bool) {    //離開這畫面就不用更新地址//
locationManager?.stopUpdatingLocation()
}

override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
}
}

