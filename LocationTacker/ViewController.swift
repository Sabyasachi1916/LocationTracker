//
//  ViewController.swift
//  LocationTacker
//
//  Created by Sabya on 24/06/20.
//  Copyright © 2020 SABYASACHI. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate  {
    var locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()

    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    var lat: Double  = 0.0
    var lng: Double  = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {status,err in
        }
        setUplocation()
    }
    
    @IBAction func setHome(){
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), radius: 30, identifier: "home")
        locationManager.startMonitoring(for: region)
    }
    
    func setUplocation(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }


    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entering region")
        scheduleLocal(str: "Hey, remember to wash your hands, welcome back home")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exiting region \(region.identifier)")
        manager.startUpdatingLocation()
        scheduleLocal(str: "Seems you are going out. Please don't forget to take mask and gloves with you.")
    }
    
    func scheduleLocal(str: String) {
         let content = UNMutableNotificationContent()
         content.title = str
         content.body = "Wash your hands"
         content.sound = UNNotificationSound.default
         content.badge = 1
         let identifier = "Home Notification"
        let triggerNow = Calendar.current.dateComponents([.hour,.minute,.second,], from: Date(timeIntervalSinceNow: 2))
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerNow, repeats: true)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lat = (locations.last?.coordinate.latitude)!
        lng = (locations.last?.coordinate.longitude)!
        lblLatitude.text = "\(lat)"
        lblLongitude.text = "\(lng)"
    }

}

