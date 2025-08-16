//
//  LocationManagerClass.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 28/02/23.
//

import UIKit
import CoreLocation
import MapKit
class LocationManagerClass: NSObject,CLLocationManagerDelegate {
    private var locationManager:CLLocationManager?
    static let shared = LocationManagerClass()
    var firstAddress: String = ""
    var secondAddress: String = ""
    var fetchedLatLong: Bool = false
var currectCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var completionAddress: ((String) -> Void)?
    override init() {
        super.init()
       
    }
    func getUserLocation() {
        self.fetchedLatLong = false
           locationManager = CLLocationManager()
           locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self

           locationManager?.startUpdatingLocation()
       }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print( "Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)")
            currectCoordinate = location.coordinate
            self.locationManager?.stopUpdatingLocation()
            
            if !self.fetchedLatLong{
                self.fetchedLatLong = true
                self.getAddressFromLatLon(coordinate: location.coordinate) { address in
                    let breaksAdd = address.components(separatedBy:", *")
                    self.firstAddress = "\(breaksAdd[0])"
                    if breaksAdd.count > 1 {
                        self.secondAddress = "\(breaksAdd[1])"
                    }
                    self.completionAddress?(address)
                    
                }
            }
        }
    }
    func getAddressFromLatLon(coordinate: CLLocationCoordinate2D, addressHandler:@escaping (String) -> Void) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            //let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            //let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            //center.latitude = lat
            //center.longitude = lon
        center = coordinate

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
                  {(placemarks, error) in
                      if (error != nil)
                      {
                          print("reverse geodcode fail: \(error!.localizedDescription)")
                      }
             guard let placemarks else{
                 addressHandler("")
                return
            }
            let pm = placemarks as [CLPlacemark]

                      if pm.count > 0 {
                          let pm = placemarks[0]
//                          print(pm.country)
//                          print(pm.locality)
//                          print(pm.subLocality)
//                          print(pm.thoroughfare)
//                          print(pm.postalCode)
//                          print(pm.subThoroughfare)
                          var addressString : String = ""
                          if pm.subLocality != nil {
                              addressString = addressString + pm.subLocality! + ", "
                          }
                          if pm.thoroughfare != nil {
                              addressString = addressString + pm.thoroughfare! + ", "
                          }
                          if pm.locality != nil {
                              addressString =  addressString + "*" + pm.locality! + ", "
                          }
                          if pm.country != nil {
                              addressString = addressString + pm.country!
                          }
                          if pm.postalCode != nil {
                              addressString = ", " + addressString + ", " + pm.postalCode! + " "
                          }


                          print(addressString)
                         // self.getAddressFromZipcode(zipcode: pm.postalCode ?? "")
                          addressHandler(addressString)

                         
                    }
              })

          }
    func getAddressFromZipcode(zipcode: String){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = zipcode//"93023"
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print(error?.localizedDescription ?? "This should be impossible")
                return
            }
          print(response.mapItems.first?.placemark.title ?? "No Placemarks")
        }
//        let geocoder = CLGeocoder()
//            let postalAddress = CNMutablePostalAddress()
//            postalAddress.postalCode = "93023"
//            geocoder.geocodePostalAddress(postalAddress, preferredLocale: Locale(identifier: "en_US")) { (placemarks, err) in
//                    if let placemark = placemarks?[0] {
//                        print(placemark)
//                        return
//                    }
//                    print(err)
//            }
    }
          
}
