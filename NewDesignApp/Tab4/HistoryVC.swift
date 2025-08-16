//
//  HistoryVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit
import Lottie
class HistoryVC: UIViewController {
    
    @IBOutlet weak var emptyImageView: LottieAnimationView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var historyTblView: UITableView!
    @IBOutlet weak var historyTypeSegment: UISegmentedControl!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginView: UIView!




    var historyList = [HistoryOrder]()
    var dineInList = [DineInOrder]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyImageView.play()
        emptyImageView.loopMode = .loop
        // Do any additional setup after loading the view.
       // self.view.backgroundColor = .red
        loginBtn.setRounded(cornerRadius: 8)
        loginBtn.setFontWithString(text: "Proceed with Email/Phone number", fontSize: 12)
        loginBtn.backgroundColor = themeBackgrounColor

        historyTypeSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        historyTypeSegment.selectedSegmentTintColor = themeBackgrounColor
        self.view.backgroundColor = .white
        historyTblView.backgroundColor = .clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if APPDELEGATE.userLoggedIn() {
            self.callService()
        } else {
            historyList = [HistoryOrder]()
            dineInList = [DineInOrder]()
            historyTblView.reloadData()
        }
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if APPDELEGATE.userLoggedIn() {
            self.callService()
        } else {
            historyList = [HistoryOrder]()
            dineInList = [DineInOrder]()
            noDataFoundRefersh()
        }
    }
    func noDataFoundRefersh(){
        if historyTypeSegment.selectedSegmentIndex == 0 && historyList.count == 0{
           // noDataFoundLbl.text = "No history Found."
            noDataFoundLbl.text = ""
        }
        else if historyTypeSegment.selectedSegmentIndex == 1 && dineInList.count == 0{
           // noDataFoundLbl.text = "No Dine Found."
            noDataFoundLbl.text = ""
        }
        else {
            noDataFoundLbl.text = ""
        }
        noDataFoundLbl.isHidden = !APPDELEGATE.userLoggedIn()
        loginView.isHidden = APPDELEGATE.userLoggedIn()
    }
    
    @IBAction func loginAction() {
        let vc = self.viewController(viewController: ProfileVC.self, storyName: StoryName.Profile.rawValue) as! ProfileVC
        vc.delegate = self
        vc.fromOtherPage = true
        self.present(vc, animated: true)
      //  print(Int(Cart.shared.getAllPriceDeatils().subTotal))
      //  print(Cart.shared.restuarant.mindelivery)
    }
    func getOrderHistoryDataFromApi() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "devicetoken" : AppConfig.DeviceToken as AnyObject,
            "app_version" : "1.0" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.orderHistory, forModelType: HisoryResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.historyList = success.data.data
            self.historyTblView.reloadData()
            self.noDataFoundRefersh()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            self.noDataFoundRefersh()
            self.historyTblView.reloadData()
        }
    }
    
    func getDineInOrdersDataFromApi() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "devicetoken" : AppConfig.DeviceToken as AnyObject,
            "app_version" : "1.0" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.getDineInOrders, forModelType: DineInHistoryResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.dineInList = success.data.dinein
            self.historyTblView.reloadData()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
            self.noDataFoundRefersh()
            self.historyTblView.reloadData()
        }
    }
    @objc func ratingAction(sender: UIButton) {
        let getTag = sender.tag
        let story = UIStoryboard.init(name: "History", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.orderID = historyList[getTag].order
        self.present(popupVC, animated: true)
    }
    
    @objc func trackOrderAction(sender: UIButton) {
        let getTag = sender.tag
        let story = UIStoryboard.init(name: "History", bundle: nil)
        let trackVC = story.instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
        trackVC.trackURL = historyList[getTag].trackorder
        self.navigationController?.pushViewController(trackVC, animated: true)
    }
    
    func callService() {
        if historyTypeSegment.selectedSegmentIndex == 0 {
            self.getOrderHistoryDataFromApi()
        } else {
            self.getDineInOrdersDataFromApi()
        }
    }
    
}
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataFoundRefersh()
        if historyTypeSegment.selectedSegmentIndex == 0 {
            return historyList.count
        } else {
            return dineInList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if historyTypeSegment.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTVCell", for: indexPath) as! HistoryTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.updateUI(order: historyList[indexPath.row])
            cell.rateBtn.tag = indexPath.row
            cell.rateBtn.addTarget(self, action: #selector(ratingAction), for: .touchUpInside)
            cell.reOrderBtn.tag = indexPath.row
            cell.reOrderBtn.addTarget(self, action: #selector(trackOrderAction), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DineInTVCell", for: indexPath) as! DineInTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.updateUI(order: dineInList[indexPath.section])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if historyTypeSegment.selectedSegmentIndex == 0 {
            let vc = self.viewController(viewController: OrderDetailVC.self, storyName: StoryName.History.rawValue) as! OrderDetailVC
            vc.hOrder = historyList[indexPath.section]
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}
extension HistoryVC: LoginSuccessDelegate {
    func signupAction() {
        let vc = self.viewController(viewController: SignupVC.self, storyName: StoryName.Profile.rawValue) as! SignupVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginCompleted() {
        self.noDataFoundRefersh()
        callService()
    }
}
extension HistoryVC: SignupSuccessfullyDelegate {
    func signupCompleted() {
        self.noDataFoundRefersh()
        callService()

    }
}
