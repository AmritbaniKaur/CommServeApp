//
//  LocationController.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 5/2/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate //MKMapViewDelegate
{

    var locationManager = CLLocationManager()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var compactAddress: String?
    lazy var geocoder = CLGeocoder()
    
    let myLocation: MKMapView =
    {
        let img = MKMapView()
        img.contentMode = .scaleToFill
        return img
    }()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        // Zooming in on annotation
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.myLocation.setRegion(region, animated: true)
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.myLocation.showsUserLocation = true
    }
    
    @objc func searchButton(_ sender: Any)
    {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        // Ignoring User
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //HideSearchBar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {(response,error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("Error")
            }
            else
            {
                // Remove Annotations
                let annotations = self.myLocation.annotations
                self.myLocation.removeAnnotations(annotations)
                
                // Getting Data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                // Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myLocation.addAnnotation(annotation)
                
                // Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myLocation.setRegion(region, animated: true)
                
                self.latitude = latitude!
                self.longitude = longitude!
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupSearch()
        
        view.addSubview(myLocation)
        myLocation.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        myLocation.showsPointsOfInterest = true
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    func setupSearch()
    {
        let searchBtn = UIButton()
        searchBtn.setImage(UIImage(named: "search"), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchButton), for: .touchUpInside)
        searchBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        searchBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        navigationItem.titleView = searchBtn
        
        let doneBtn = UIButton()
        doneBtn.setImage(UIImage(named: "Checked-icon"), for: .normal)
        doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        doneBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let rightBtn = UIBarButtonItem()
        rightBtn.customView = doneBtn
        
        navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    @objc func doneAction() //_ sender: UIButton)
    {
        // Create Location
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        
        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?)
    {
        if let error = error
        {
            print("Unable to Reverse Geocode Location (\(error))")
        }
        else
        {
            if let placemarks = placemarks, let placemark = placemarks.first
            {
                self.compactAddress = placemark.compactAddress!
                
                let a = self.navigationController?.viewControllers[0] as! AddPostController
                a.location = placemark.compactAddress!
                self.navigationController?.popToRootViewController(animated: true)
            }
            else
            {
                print("No Matching Addresses Found")
            }
        }

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension CLPlacemark
{
    
    var compactAddress: String?
    {
        if let name = name {
            var result = name
            
            if let street = thoroughfare
            {
                result += ", \(street)"
            }
            
            if let city = locality
            {
                result += ", \(city)"
            }
            
            if let country = country
            {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}
