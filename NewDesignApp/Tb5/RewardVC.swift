//
//  RewardVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 30/10/24.
//

import UIKit

class RewardVC: UIViewController {
    @IBOutlet weak var rewardTbl: UITableView!
    @IBOutlet weak var myRewardPointsLbl: UILabel!
    var rewardResponse: RewardResponse!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myRewardPointsLbl.text = "$ 0.0"
        getRewardFromApi()
        self.view.backgroundColor = .white
        rewardTbl.backgroundColor = .white
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func updateUI() {
        myRewardPointsLbl.text = "$ \(rewardResponse.Rewards)"
        rewardTbl.reloadData()
    }
    func getRewardFromApi() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "devicetoken" : AppConfig.DeviceToken as AnyObject,
            "app_version" : "1.0" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.getReward, forModelType: RewardResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.rewardResponse = success.data
           // self.favTbl.reloadData()
            self.updateUI()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }

}
extension RewardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.rewardResponse != nil else {
            return 0
        }
         return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardTVCell", for: indexPath) as! RewardTVCell
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        
        switch indexPath.row {
        case 0:
            cell.rewardTypeLbl.text = "  Total Points"
            cell.rewardPointLbl.text = "Points \(self.rewardResponse.Points)"
            cell.rewardBucksLbl.text = "GB Bucks $ \(self.rewardResponse.PointsGB)"
        case 1:
            cell.rewardTypeLbl.text = "  Friend Referrals"
            cell.rewardPointLbl.text = "Friends \(self.rewardResponse.Freind ?? 0)"
            cell.rewardBucksLbl.text = "GB Bucks $ \(self.rewardResponse.FreindGB ?? 0)"
        default:
            cell.rewardTypeLbl.text = "  Restaurant Referrals"
            cell.rewardPointLbl.text = "Restaurants \(self.rewardResponse.Restaurant ?? 0)"
            cell.rewardBucksLbl.text = "GB Bucks $ \(self.rewardResponse.RestaurantGB ?? 0)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
}
