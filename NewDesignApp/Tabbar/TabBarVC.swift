//
//  TabBarVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dashboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let mainS = UIStoryboard(name: "Main", bundle: nil)
        let search = UIStoryboard(name: "FoodSearch", bundle: nil)
        let history = UIStoryboard(name: "History", bundle: nil)
        let profile = UIStoryboard(name: "Profile", bundle: nil)
        
        let dashBoardVC = dashboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
        let restaurantVC = mainS.instantiateViewController(withIdentifier: "RestaurantVC") as! RestaurantVC
        let foodSearchVC = search.instantiateViewController(withIdentifier: "FoodSearchVC") as! FoodSearchVC

        let historyVC = history.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        let profileVC = profile.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC

       // let dashBoardVCNav = UINavigationController(rootViewController: dashBoardVC)
        dashBoardVC.title = "Food"
       // dashBoardVCNav.isNavigationBarHidden = true
        dashBoardVC.tabBarItem.image = UIImage(named: "Food")
        
      //  let restaurantVCNav = UINavigationController(rootViewController: restaurantVC)
        restaurantVC.title = "Home"
        restaurantVC.tabBarItem.image = UIImage(named: "home")
       // restaurantVCNav.isNavigationBarHidden = true
        
        //  let foodSearchVCNav = UINavigationController(rootViewController: foodSearchVC)
        foodSearchVC.title = "Search"
        foodSearchVC.tabBarItem.image = UIImage(named: "search")
         // foodSearchVCNav.isNavigationBarHidden = true
        
       // let historyVCNav = UINavigationController(rootViewController: historyVC)
        historyVC.title = "History"
       // historyVC.isNavigationBarHidden = true
        historyVC.tabBarItem.image = UIImage(named: "history")
        
       // let profileVCNav = UINavigationController(rootViewController: profileVC)
        profileVC.title = "Profile"
       // profileVCNav.isNavigationBarHidden = true
        profileVC.tabBarItem.image = UIImage(named: "profileIcon")
               //navigationController.tabBarItem.image = UIImage.init(named: "map-icon-1")
        
        self.tabBar.tintColor = themeBackgrounColor
        self.tabBar.backgroundColor = kGrayColor
       // self.tabBarItem.item = UIImage(named: "profileIcon24")

              viewControllers = [dashBoardVC, restaurantVC, foodSearchVC, historyVC, profileVC]


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
