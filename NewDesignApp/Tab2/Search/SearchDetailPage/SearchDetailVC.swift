//
//  SearchDetailVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 29/01/25.
//

import UIKit

class SearchDetailVC: UIViewController {
    var listResponse = [Restaurant]()
    var cuisine = ""
    var isDineFilter = false
    @IBOutlet weak var similarTbl: UITableView!
    @IBOutlet weak var titleLbl: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLbl.text = isDineFilter ? "Dine In Restaurants" : "Restaurants"
        similarTbl.backgroundColor = .white
        self.view.backgroundColor = .white
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listResponse.count == 0 {
            getRestDataFromApi()
        }
    }
    func getRestDataFromApi() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "DeviceToken" : AppConfig.DeviceToken as AnyObject,
            "DeviceVersoin" : "1.0" as AnyObject,
           // "rest_zip" : "\(APPDELEGATE.selectedLocationAddress.zipcode ?? "")" as AnyObject,
            "rest_zip" : "01801" as AnyObject,

            "cust_lat" : "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)" as AnyObject,
            "cust_long" : "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
            "cuisine_type" : cuisine as AnyObject,
            "address" : "\(UtilsClass.getFullAddress())" as AnyObject

        ]
            UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.resturantList, forModelType: RestaurantListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            if success.data.restaurant.count > 0 {
                self.listResponse = success.data.restaurant
                self.dineFilter()
            }
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
        
    }
    func dineFilter() {
        if isDineFilter {
            let filtered = self.listResponse.filter { $0.ordertypes.contains("Reservation") }
           // print(filtered.count)
           // print(self.listResponse.count)
            self.listResponse = filtered
           // print(self.listResponse.count)
        }
        self.similarTbl.reloadData()

    }
    func getRestDetailFromApi(restid: String) {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "rest_id" : restid as AnyObject
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.restaurantDetail, forModelType: RestDetailResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "RestDetailsVC") as! RestDetailsVC
            vc.restDetailsData = success.data.restaurant
            self.navigationController?.pushViewController(vc, animated: true)
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }

}

extension SearchDetailVC: RestCellDelegate {
    func clickedFavAction(index: Int) {
        
    }
    
    func openOptionView(sender: UITapGestureRecognizer, index: Int) {
        let point = sender.location(in: self.view)
        let popupVC = self.viewController(viewController: RestaurantPoupVC.self, storyName: StoryName.Main.rawValue) as! RestaurantPoupVC

        popupVC.pointY = Float(point.y)
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
}
extension SearchDetailVC: SelectOptionDelegate {
    func selectedOption(restIndex: Int, index: Int) {
        
    }
}

extension SearchDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listResponse.count == 0 {
            return 1
        }
        return listResponse.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if listResponse.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoRestaurantTVCell", for: indexPath) as! NoRestaurantTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestDetailCell", for: indexPath) as! RestDetailCell
            cell.delegate = self
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.updateUIWithOld(index: indexPath.row, restaurant: listResponse[indexPath.row])
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listResponse.count == 0 {
            return 390
        } else {
            return 170
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listResponse.count > 0 {
            if isDineFilter {
                            let vc = self.viewController(viewController: DineInReservationVC.self, storyName: StoryName.DineIn.rawValue) as! DineInReservationVC
                            self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let rest = self.listResponse[indexPath.row]
                self.getRestDetailFromApi(restid: rest.id)
            }
        } else {
                let vc = self.viewController(viewController: LocationVC.self, storyName: StoryName.Location.rawValue) as! LocationVC
            vc.fromSearch = true
                self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
