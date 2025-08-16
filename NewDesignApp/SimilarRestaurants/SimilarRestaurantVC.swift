//
//  SimilarRestaurantVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/09/24.
//

import UIKit

class SimilarRestaurantVC: UIViewController {
    var favoriteListResponse: FavoriteListResponse?
    @IBOutlet weak var similarTbl: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
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
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.favoriteRest, forModelType: FavoriteListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.favoriteListResponse = success.data
            self.similarTbl.reloadData()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
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
extension SimilarRestaurantVC: RestCellDelegate {
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
extension SimilarRestaurantVC: SelectOptionDelegate {
    func selectedOption(restIndex: Int, index: Int) {
        
    }
}

extension SimilarRestaurantVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let favList = favoriteListResponse?.data?.rest_list else {
            return 0
        }
        return favList.list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestDetailCell", for: indexPath) as! RestDetailCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        
        guard let favList = favoriteListResponse?.data?.rest_list else {
            return cell
        }
        //cell.updateUIWithOld(index: 0, restaurant: favList.list[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
