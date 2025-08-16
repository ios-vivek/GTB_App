//
//  HiddenRestVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 31/08/24.
//

import UIKit

class HiddenRestVC: UIViewController {
    var hiddenListResponse: FavoriteListResponse?
    @IBOutlet weak var hiddenTbl: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        hiddenTbl.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRestDataFromApi()
    }
    func getRestDataFromApi() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "devicetoken" : AppConfig.DeviceToken as AnyObject,
            "app_version" : "1.0" as AnyObject,
            "cust_lat" : "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)" as AnyObject,
            "cust_long" : "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.hiddenRestList, forModelType: FavoriteListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.hiddenListResponse = success.data
            self.hiddenTbl.reloadData()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func setHiddenRestaurant(index: Int) {
        let rest = hiddenListResponse?.data?.rest_list.list[index]
        let favStr = "Remove"
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "devicetoken" : AppConfig.DeviceToken as AnyObject,
            "app_version" : "1.0" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
            "restaurant_id" : rest?.restaurant_id as AnyObject,
            "hiddenType" : favStr as AnyObject
        ]
        print(parameters)
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.hiddenRest, forModelType: AddRemoveFavRestResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
//            let addRemoveFavRestResponse = success.data.result
//            self.showAlert(msg: addRemoveFavRestResponse ?? "")
            self.getRestDataFromApi()
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

}
extension HiddenRestVC: RestCellDelegate {
    func clickedFavAction(index: Int) {
        setHiddenRestaurant(index: index)
    }
    
    func openOptionView(sender: UITapGestureRecognizer, index: Int) {
        let point = sender.location(in: self.view)
        let popupVC = self.viewController(viewController: RestaurantPoupVC.self, storyName: StoryName.Main.rawValue) as! RestaurantPoupVC

        popupVC.pointY = Float(point.y)
        popupVC.numberOfItem = 1
        popupVC.textOne = "Unhide this restaurant"
        popupVC.textTwo = ""
        popupVC.textThree = ""
        popupVC.firstImg = UIImage.init(named: "unhideIcon")
        popupVC.secondImg = UIImage.init(named: "")
        popupVC.thirdImg = UIImage.init(named: "")
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
}
extension HiddenRestVC: SelectOptionDelegate {
    func selectedOption(restIndex: Int, index: Int) {
        setHiddenRestaurant(index: restIndex)
    }

}

extension HiddenRestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let hiddenList = hiddenListResponse?.data?.rest_list else {
            return 0
        }
        return hiddenList.list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestDetailCell", for: indexPath) as! RestDetailCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        guard let hidddenList = hiddenListResponse?.data?.rest_list else {
            return cell
        }
        //cell.updateUIWithOld(index: 0, restaurant: hidddenList.list[indexPath.row])
        cell.favImage.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
