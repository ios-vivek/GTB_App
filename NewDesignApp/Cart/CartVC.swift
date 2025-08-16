//
//  CartVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/10/24.
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var proceedView: UIView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    var completeItemList = [RestInnerMenu]()
    var allDisplayItems = [RestInnerMenu]()
    //var allMenuList = [RestMenu]()
    var isOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
       // let seletedTime = SeletedTime.init(date: UtilsClass.getCurrentDateInString(date: Date()), time: "00:00 am", heading: "Pickup today ASAP")
       // Cart.shared.selectedTime = seletedTime
        var fullText = "Order"
        var firstPart = "Order"
        var secondPart = ""
        titlelbl.text = "Order"
        if Cart.shared.restDetails != nil {
            firstPart = ""
            fullText = "\(Cart.shared.restDetails.name)"
            secondPart = "\(Cart.shared.restDetails.name)"
            let deliveryZipsArray = Cart.shared.restDetails.deliveryzip.components(separatedBy: ",")
            if Cart.shared.userAddress == nil && APPDELEGATE.userLoggedIn(){
                for address in APPDELEGATE.userResponse!.customer.address! {
                    if deliveryZipsArray.contains(address.zip) {
                        Cart.shared.userAddress = address
                        break
                    }
                }
            }
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)

        // First part in red
        attributedString.addAttribute(.foregroundColor,
                                      value: kOrangeColor,
                                       range: NSRange(location: 0, length: firstPart.count))

        // Second part in blue
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.black,
                                       range: NSRange(location: firstPart.count, length: secondPart.count))

        titlelbl.attributedText = attributedString
        loginBtn.setRounded(cornerRadius: 8)
        loginBtn.setFontWithString(text: "Proceed with Email/Phone number", fontSize: 12)
        addressBtn.setRounded(cornerRadius: 8)
        addressBtn.setFontWithString(text: "Add or Select address", fontSize: 12)
        loginBtn.backgroundColor = themeBackgrounColor
        addressBtn.backgroundColor = themeBackgrounColor
        proceedBtn.setRounded(cornerRadius: 8)
        proceedBtn.setFontWithString(text: "Add or Select address", fontSize: 12)
        proceedBtn.backgroundColor = themeBackgrounColor
        self.setDefaultBack()
        self.view.backgroundColor = .white
        cartTableView.backgroundColor = .white

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
        if Cart.shared.orderType == .delivery {
            self.getAddressesFromApi()
        }
        Cart.shared.isReward = false
        Cart.shared.rewardAmount = 0.0
    }
   
    func getAddressesFromApi() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "devicetoken" : AppConfig.DeviceToken as AnyObject,
            "app_version" : "1.0" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.getAddress, forModelType: GetAddressResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            APPDELEGATE.userResponse?.customer.address = success.data.address
           UtilsClass.saveUserDetails()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func refreshView() {
        emptyView.isHidden = Cart.shared.cartData.count > 0 ? true : false
        cartTableView.isHidden = Cart.shared.cartData.count > 0 ? false : true
        loginView.isHidden = true
        addressView.isHidden = true
        proceedView.isHidden = true
        if !APPDELEGATE.userLoggedIn() {
            loginView.isHidden = cartTableView.isHidden
        }
        if APPDELEGATE.userLoggedIn() && Cart.shared.orderType == .delivery {
            addressView.isHidden = cartTableView.isHidden
            if Cart.shared.userAddress != nil {
                addressView.isHidden = true
            }
        }
        if APPDELEGATE.userLoggedIn() && Cart.shared.orderType == .pickup {
            proceedView.isHidden = cartTableView.isHidden
        }
        else if APPDELEGATE.userLoggedIn() && Cart.shared.orderType == .delivery {
            proceedView.isHidden = !addressView.isHidden
        }
        let val = Cart.shared.roundValue2Digit(value: Cart.shared.getAllPriceDeatils().total)
        proceedBtn.setFontWithString(text: "Proceed: \(UtilsClass.getCurrencySymbol())\(val)", fontSize: 12)
        //let completemeal = ["2022062007443232", "2022062007333515"]
       // Cart.shared.restDetails.completeMealList = [String]()
        //Cart.shared.restDetails.completeMealList.append(contentsOf: completemeal)
        getAllItemsForNextVCDisplay()
        self.cartTableView.reloadData()
    }
    func getAllItemsForNextVCDisplay() {
        allDisplayItems = [RestInnerMenu]()
       // print("Cart.shared.cartData--\(Cart.shared.cartData)")
        for item in Cart.shared.cartData {
           // print("allMenuList--\(allMenuList.count)")
            if Cart.shared.tempAllRestmenu.count > 0 {
                for menuItem in Cart.shared.tempAllRestmenu {
                   // print("menuItem.submenu--\(menuItem.submenu)")
                    if menuItem.submenu == "No" {
                        for itemData in menuItem.itemList2! {
                            self.addItemInCompleteMeal(menuItem: menuItem, item: item, itemData: itemData)
                        }
                    } else {
                        for itemData in menuItem.itemList2! {
                            self.addItemInCompleteMeal(menuItem: menuItem, item: item, itemData: itemData)
                        }
                    }
                }
            }
        }
        removeItemFromCompleteMealList()
       
    }
    func addItemInCompleteMeal(menuItem: RestMenu, item: CartItemList, itemData: RestItemList) {
//        print("idss--\(itemData.id)")
//        print("completeMeal--\(item.restItem.completeMeal)")
//        print("completeMeal--\(Cart.shared.restDetails.completeMealList)")
        if item.restItem.completeMeal == "Yes" && Cart.shared.restDetails.completeMealList.contains(itemData.id){
            let item = RestItemList(completeMeal: itemData.completeMeal, id: itemData.id, heading: itemData.heading, details: itemData.details, sm: itemData.sm, md: itemData.md, lg: itemData.lg, ex: itemData.ex, xl: itemData.xl, minqty: itemData.minqty)
            let menu = RestInnerMenu(id: menuItem.id, heading: menuItem.heading, url: menuItem.url, sms: menuItem.sms, mds: menuItem.mds, lgs: menuItem.lgs, exs: menuItem.exs, xls: menuItem.xls, itemList: [item])
            let indexOfPerson1 = allDisplayItems.firstIndex{$0.itemList![0].id == itemData.id} // 0
            if indexOfPerson1 == nil {
                allDisplayItems.append(menu)
            }
            
        }
    }
    func removeItemFromCompleteMealList() {
        completeItemList = [RestInnerMenu]()

        let tempArray = allDisplayItems
        var removeindex = -1
        for item in tempArray{
            removeindex = -1
            for element in Cart.shared.cartData  {
                if item.itemList![0].id == element.restItem.id {
                    let indexOfPerson1 = allDisplayItems.firstIndex{$0.itemList![0].id == element.restItem.id} // 0
                    removeindex = indexOfPerson1 ?? 0
                    break
                }
            }
            if removeindex > -1 {
                allDisplayItems.remove(at:removeindex)
            }
        }
        completeItemList = allDisplayItems
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func loginAction() {
        let vc = self.viewController(viewController: ProfileVC.self, storyName: StoryName.Profile.rawValue) as! ProfileVC
        vc.delegate = self
        vc.fromOtherPage = true
        self.present(vc, animated: true)
    }
    @IBAction func addressAction() {
        let story = UIStoryboard.init(name: "Profile", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ChooseAddressVC") as! ChooseAddressVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        self.present(popupVC, animated: true)
    }
    func clickedOnChangeTime() {
        let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ScheduleDateTimeVC") as! ScheduleDateTimeVC
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
    @IBAction func proceedAction() {
        if Cart.shared.orderType == .delivery && Cart.shared.restDetails.restMindelivery > Cart.shared.getAllPriceDeatils().subTotal {
            let alertController = UIAlertController(title: "Add more items", message: "Min order \(UtilsClass.getCurrencySymbol())\(Cart.shared.restDetails.restMindelivery) for delivery", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Add", style: .default) { action in
                self.navigationController?.popViewController(animated: true)

            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
                
            }
            alertController.addAction(OKAction)
            alertController.addAction(cancel)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
        } else {
            if ((Cart.shared.restDetails.openstatus.contains("Closed") || Cart.shared.restDetails.openstatus.contains("closed")) && Cart.shared.orderDate == .ASAP){
                let alertController = UIAlertController(title: "Alert", message: "Restaurant is closed for now. Please change your delivery / pickup timing.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                    self.clickedOnChangeTime()

                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
                    
                }
                alertController.addAction(OKAction)
                alertController.addAction(cancel)
                OperationQueue.main.addOperation {
                    self.present(alertController, animated: true,
                                 completion:nil)
                }
                return
            }
            let vc = self.viewController(viewController: ConfirmOrderVC.self, storyName: StoryName.CartFlow.rawValue) as! ConfirmOrderVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
      
    }
    
    func openItemDetails(itemlist: RestItemList, index: IndexPath) {
        if(!isOpen)

           {
               isOpen = true
            let menuVC = self.viewController(viewController: ItemDetailsVC.self, storyName: StoryName.Main.rawValue) as! ItemDetailsVC
            menuVC.itemData = itemlist
            menuVC.index = index

            menuVC.delegate = self
            menuVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
               self.view.addSubview(menuVC.view)
            self.addChild(menuVC)
               menuVC.view.layoutIfNeeded()

               menuVC.view.frame=CGRect(x: 0, y: 0 + UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);

               UIView.animate(withDuration: 0.3, animations: { () -> Void in
                   menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
               }) { completion in
                   self.tabBarController?.tabBar.isHidden = true
               }

           }else if(isOpen)
           {
               closedPopup()
           }
    }
    func closedPopup() {
        isOpen = false
        let viewMenuBack : UIView = view.subviews.last!

          UIView.animate(withDuration: 0.3, animations: { () -> Void in
              var frameMenu : CGRect = viewMenuBack.frame
              frameMenu.origin.y = 1 * UIScreen.main.bounds.size.height
              viewMenuBack.frame = frameMenu
              viewMenuBack.layoutIfNeeded()
              viewMenuBack.backgroundColor = UIColor.clear
          }, completion: { (finished) -> Void in
              viewMenuBack.removeFromSuperview()
              self.tabBarController?.tabBar.isHidden = false

          })
    }

}
extension CartVC: ReloadAddressDelegate {
    func changedAddress() {
        refreshView()
    }
    
    func addNewAddress() {
        let vc = self.viewController(viewController: AddAddressVC.self, storyName: StoryName.Profile.rawValue) as! AddAddressVC
        vc.isUpdateAddress = false
        vc.fromCheckoutPage = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension CartVC: ReloadNewAddressDelegate {
    func addednewAddress() {
        refreshView()
    }
    
}
extension CartVC: LoginSuccessDelegate {
    func signupAction() {
        let vc = self.viewController(viewController: SignupVC.self, storyName: StoryName.Profile.rawValue) as! SignupVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginCompleted() {
        self.refreshView()
        if Cart.shared.orderType == .pickup {
            self.proceedAction()
    }
    }
}
extension CartVC: SignupSuccessfullyDelegate {
    func signupCompleted() {
        self.refreshView()
        if Cart.shared.orderType == .pickup {
            self.proceedAction()
    }

    }
}
extension CartVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if Cart.shared.orderType == .delivery && Cart.shared.userAddress != nil {
            return 4
        }
        return 3

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Cart.shared.cartData.count
        }
        if section == 1 {
            return completeItemList.count > 0 ? 1 : 0
        }
      return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemTVCell", for: indexPath) as! CartItemTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.delegate = self
            cell.deleteButton.tag = indexPath.row
            cell.updateUI(index: indexPath.row)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreItemTVCell", for: indexPath) as! MoreItemTVCell
        cell.selectionStyle = .none
            cell.suggestedItemList = self.completeItemList
            cell.delegate = self
            cell.itemCollection.reloadData()
        // cell.updateUI(offer: self.restDetailsData?.offer ?? [RestOffer]())
        return cell
    }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartPriceDetailsTVCell", for: indexPath) as! CartPriceDetailsTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .gGray100
            cell.delegate = self
            cell.updateUI(isPlaceOrder: false)
            cell.tipsLbl.isHidden = true
            cell.donateLbl.isHidden = true
            cell.selectionStyle = .none
            return cell
        }
    
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAtTVCell", for: indexPath) as! DeliveryAtTVCell
            cell.selectionStyle = .none
            if Cart.shared.cartData.count > 0 {
                var add = ""
                if Cart.shared.orderType == .pickup {
                    cell.headingLbl.text = "Pickup From:"
                    add = "\(Cart.shared.restDetails.address), \(Cart.shared.restDetails.city), \(Cart.shared.restDetails.state), \(Cart.shared.restDetails.zip)"
                    cell.changeAddressBtn.isHidden = true
                    cell.changePhoneBtn.isHidden = true
                    cell.phoneLbl.text = "Phone: \(Cart.shared.restDetails.phone)"
                }else {
                    cell.headingLbl.text = "Delivery At:"
                    let address = Cart.shared.userAddress
                    add = "\(address!.add1) \(address!.add2), \(address!.city), \(address!.state), \(address!.zip)"
                    cell.changeAddressBtn.isHidden = false
                    cell.changePhoneBtn.isHidden = false
                    cell.phoneLbl.text = "Phone: \(APPDELEGATE.userResponse?.customer.phone ?? "")"
                    if Cart.shared.alternateNumber.count == 10 {
                        cell.phoneLbl.text = "Phone: \(Cart.shared.alternateNumber)"
                    }
                    
                }
                
                cell.delegate = self
                cell.deliveryAtLbl.text = add
            }
            
           
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 195
        }
        return UITableView.automaticDimension
    }
}
extension CartVC: ChangeAddressDelegate {
    func changeAddress() {
        let story = UIStoryboard.init(name: "Profile", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ChooseAddressVC") as! ChooseAddressVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        self.present(popupVC, animated: true)
    }
    
    func changePhone() {
        let story = UIStoryboard.init(name: "CartFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ChangePhoneVC") as! ChangePhoneVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        self.present(popupVC, animated: true)
    }
}
extension CartVC: ChangePhoneNumberDelegate {
    func changesNumber() {
        cartTableView.reloadData()
    }
}
extension CartVC: DeleteDelegate {
    func deleteItem(index: Int) {
        Cart.shared.cartData.remove(at: index)
        self.refreshView()
        /*
        let alertController = UIAlertController(title: "Delete", message: "Are you sure want to delete item?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
            Cart.shared.cartData.remove(at: index)
            self.refreshView()

        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true,
                         completion:nil)
        }
         */
    }
    func refereshItemList() {
        self.refreshView()
    }
        
}
extension CartVC: CheckoutDelegate {
    func emptyAction() {
        let alertController = UIAlertController(title: "Empty cart", message: "Are you sure want to empty?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
            Cart.shared.cartData.removeAll()
            self.refreshView()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true,
                         completion:nil)
        }
        
    }
    
    func checkoutAction() {
        if Cart.shared.restDetails.restMindelivery > Cart.shared.getAllPriceDeatils().subTotal {
            let alertController = UIAlertController(title: "Add more items", message: "Min order \(UtilsClass.getCurrencySymbol())\(Cart.shared.restDetails.restMindelivery) for delivery", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Add", style: .default) { action in
                self.navigationController?.popViewController(animated: true)

            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
                
            }
            alertController.addAction(OKAction)
            alertController.addAction(cancel)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
        } else {
            let vc = self.viewController(viewController: ConfirmOrderVC.self, storyName: StoryName.CartFlow.rawValue) as! ConfirmOrderVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
      
    }
   
}
extension CartVC: DateChangedDelegate {
    func dateChanged() {
        self.proceedAction()
    }
}
extension CartVC: ItemDetailsDelegate {
    func itemClosed() {
        closedPopup()
    }
    
    func openSelectSize(index: IndexPath) {
        self.addItemSelection(index: index)
    }
    
    func addItemSelection(index: IndexPath) {
        if Cart.shared.restDetails == nil {
            Cart.shared.restDetails = Cart.shared.tempRestDetails
            //self.navigateToMenuDetails(index: index)
            self.closedPopup()
        }
        else if Cart.shared.restDetails.id != Cart.shared.tempRestDetails.id {
            if Cart.shared.cartData.count > 0 {
                let alertController = UIAlertController(title: "Replace cart item?", message: "Your cart contains dishes from \(Cart.shared.restDetails.name). Do you want to discart the selection and add dishes from \(Cart.shared.tempRestDetails.name)?", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                    Cart.shared.cartData.removeAll()
                    Cart.shared.restDetails = Cart.shared.tempRestDetails
                   // self.navigateToMenuDetails(index: index)
                    self.closedPopup()
                    
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alert in
                    
                }
                alertController.addAction(OKAction)
                alertController.addAction(cancel)
                OperationQueue.main.addOperation {
                    self.present(alertController, animated: true,
                                 completion:nil)
                }
            } else {
                Cart.shared.restDetails = Cart.shared.tempRestDetails
                //self.navigateToMenuDetails(index: index)
                self.closedPopup()
            }
                }
        else {
            
            let newItem = completeItemList[index.section].itemList![index.row]
            Cart.shared.itemData = newItem
            var newSize = Cart.shared.getAllSizes(menu: Cart.shared.tempRestmenu, item: newItem)[0]
            newSize.itemQty = 1
            Cart.shared.itemSizes = [Sizes]()
            Cart.shared.itemSizes.append(newSize)
            Cart.shared.selectedTopping = [SelectedTopping]()
            Cart.shared.itemExtra = 0.0
            Cart.shared.instructionText = ""
            Cart.shared.itemExtra = 0.0
            Cart.shared.addInCart()
            self.closedPopup()
            self.refreshView()
        }
    }
}
extension CartVC: OpenItemDetailDelegate {
    func addItemInList(index: IndexPath) {
        let newItem = completeItemList[index.section].itemList![index.row]
        Cart.shared.itemData = newItem
            var newSize = Cart.shared.getAllSizes(menu: Cart.shared.tempRestmenu, item: newItem)[0]
            newSize.itemQty = 1
            Cart.shared.itemSizes = [Sizes]()
            Cart.shared.itemSizes.append(newSize)
            Cart.shared.selectedTopping = [SelectedTopping]()
        Cart.shared.itemExtra = 0.0
        Cart.shared.instructionText = ""
        Cart.shared.itemExtra = 0.0
        Cart.shared.addInCart()
        self.refreshView()
    }
    
    func selectedItem(index: IndexPath) {
        self.openItemDetails(itemlist: completeItemList[index.section].itemList![index.row], index: index)
    }
    
}
