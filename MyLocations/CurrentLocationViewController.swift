//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Eoghan on 2018-06-06.
//  Copyright © 2018 Vestego. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }



    //Because you hooked up the Get Location button on the main storyboard
    //and that this is an ACTION function, basically when the button is clicked, this code is run
    //this code is telling the system to pull the most latest location
    @IBAction func getLocation() {
        //find out the current status of location authorisation (i.e if the user has authorised before or not)
        let authStatus = CLLocationManager.authorizationStatus()
        
        //if the user hasn't granted persmission again, the app will give a pop up asking to allow location
        if authStatus == .notDetermined {
        locationManager.requestAlwaysAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError > \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        location = newLocation
        updateLabels()
    }
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longtitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longtitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = "Tap 'Get My Location' to Start"
        }
    }
    
    //The below is error handling for when the user has denied access to the location
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

