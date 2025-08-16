//
//  AppDelegate.swift
//  NewDesignApp
// https://www.grabull.com/web-api/
//pass - admin / api_gb@2019


//  Created by Vivek SIngh on 09/08/24.
//https://www.webapi.grabulldemo.com/
//adminGD/api_gd@2020
//https://lottiefiles.com/blog/working-with-lottie-animations/how-to-add-lottie-animation-ios-app-swift/
import UIKit
import CoreLocation
import IQKeyboardManagerSwift

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var applicationActive: Bool = false
    var gotLocation: Bool = false
    var timr=Timer()


    var userResponse: UserResponse?

    var selectedLocationAddress = LocationAddress()
    var cusines: CuisineResponse?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true

        setupLoactionManager()
        UtilsClass.getuserDetails()
        UtilsClass.getCousines()
        return true
    }
    func userLoggedIn()-> Bool {
        guard APPDELEGATE.userResponse != nil else {
            return false
        }
        return true
    }
    func getCousins()-> [Cuisine] {
        guard let user = APPDELEGATE.cusines else {
            return [Cuisine]()
        }
        return user.cuisine
    }
    func getCoupons()-> [Coupon] {
        guard let user = APPDELEGATE.cusines else {
            return [Coupon]()
        }
        return user.coupon
    }
    func getSlider()-> [RestSlider] {
        guard let user = APPDELEGATE.cusines else {
            return [RestSlider]()
        }
        return user.slider
    }
    func getBanner()-> String {
        guard let user = APPDELEGATE.cusines else {
            return ""
        }
        return user.banner
    }
    func getCusineheading()-> String {
        guard let user = APPDELEGATE.cusines else {
            return ""
        }
        return user.cuisine_heading
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setupLoactionManager() {
        locationManager.requestWhenInUseAuthorization();
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        else{
            print("Location service disabled");
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if (gotLocation == false){
            gotLocation = true
            UtilsClass.getAddressFromLoaction(userLocation: locations[0] as CLLocation) { (userAddress) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "location"), object: nil)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Location manager failed with error = \(error.localizedDescription)")
        if !applicationActive{
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.applicationActive = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorlocation"), object: nil)

        }
        }
    }


}

extension UIViewController: UIGestureRecognizerDelegate {
    public func setDefaultBack() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
}
