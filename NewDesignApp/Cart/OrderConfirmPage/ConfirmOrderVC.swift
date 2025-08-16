//
//  ConfirmOrderVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit
enum PayBy {
    case Cash
    case Card
    case Gift
}
enum CellTypeSelected: Int {
    case Restname
    case Deliveryto
    case Deliveryat
    case SendAsGift
    case Special
    case Payment
    case Redeem
    case Tips
    case Donate
    case Itemdetails
    case Totalprice
    case TotalRowsCount
}
class ConfirmOrderVC: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
//let sectionArr = ["restname","deliveryto", "deliveryat", "SendAsGift", "Special","payment", "Redeem", "tips", "donate", "itemdetails", "totalprice"]
var selectePaymenType = 0
    var payBy = PayBy.Card
    var isSpecialSelected = false
    var userRewardAmount: String = "0.0"
    var recipientfName: String = ""
    var recipientlName: String = ""
    var recipientPhone: String = ""
    var orderAsGift: String = "No"
    override func viewDidLoad() {
        super.viewDidLoad()
        Cart.shared.isTips = false
        Cart.shared.isDonate = false
        Cart.shared.tipsAmount = 0.0
        Cart.shared.donateAmount = 0.0
        Cart.shared.alternateNumber = ""
        Cart.shared.isReward =  false
        Cart.shared.rewardAmount =  0.0
        Cart.shared.cardNumber = ""
        Cart.shared.cardCvv = ""
        Cart.shared.cardExpiry = ""
        Cart.shared.cardHolder = ""
        Cart.shared.cardZip = ""
        // Do any additional setup after loading the view.
        getRewardFromApi()
        self.setDefaultBack()
        self.view.backgroundColor = .white
        cartTableView.backgroundColor = .white

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
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
            self.userRewardAmount = success.data.Rewards
            Cart.shared.rewardAmount = Float(success.data.Rewards) ?? 0.0
            self.cartTableView.reloadData()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func setAmountValue(sizes: Sizes, toppings: [SelectedTopping])-> Float {
        var price: Float = 0.0
        price = Float(sizes.price)! * Float(sizes.itemQty)

        var toppingsPrice: Float = 0.0
        for topping in toppings {
            for option in topping.option {
                toppingsPrice = toppingsPrice + option.price
            }
        }
       price = price + toppingsPrice
        
        return price

    }
    func getitemList() -> [Dictionary<String, AnyObject>]{
        var itemArray: [Dictionary<String, AnyObject>] = []
        var items = [String: AnyObject]()
        for item in Cart.shared.cartData {
            let size = item.restItemSizes.first!
            var toppings = ""
            var totalToppingPrice: Float = 0.0
            for topping in item.restItemTopping {
                for option in topping.option {
                    var opPrice = ""
                    if option.price > 0 {
                        opPrice = " \(option.price)"
                    }
                    if toppings.count == 0 {
                        toppings = "\(option.optionHeading)\(opPrice)"
                    } else {
                        toppings = "\(toppings) | \(option.optionHeading)\(opPrice)"
                    }
                    totalToppingPrice = totalToppingPrice + Float(option.price)
                }
            }
           // totalToppingPrice = totalToppingPrice + Cart.shared.itemExtra
           // totalToppingPrice = Cart.shared.roundValue2Digit(value: (totalToppingPrice + Cart.shared.itemExtra))
            totalToppingPrice = Cart.shared.roundValue2Digit(value: (totalToppingPrice))

            /*
            var toppingList = [[String: AnyObject]]()
            var optionList = [[String: AnyObject]]()
            
            let option = [
                "id" : "" as AnyObject,
                "heading" : "" as AnyObject,
                "price" : "" as AnyObject
                ]
            optionList.append(option)
            let topping = [
                "id" : "" as AnyObject,
                "heading" : "" as AnyObject,
                "options" : optionList as AnyObject
                ]
            toppingList.append(topping)
            */
            
            items = [
                "id" : item.restItem.id as AnyObject,
                "mid" : size.manuId as AnyObject,
                "heading" : "\(item.restItem.heading) (\(size.manuName))" as AnyObject,
                "qty" : "\(size.itemQty)" as AnyObject,
                "size" : "\(size.name)" as AnyObject,
                "price" : "\(size.price)" as AnyObject,
                "extra" : "\(toppings)" as AnyObject,
                "extamount" : "\(totalToppingPrice)" as AnyObject,
                "extracharge" : "\(Cart.shared.roundValue2Digit(value: item.instructionExtraAmount))" as AnyObject,
                "addedInst" : "\(item.instructionText)" as AnyObject,
                "toppingList": "" as AnyObject,
                ]
//            let addedItem = [
//                "id" : item.restItem.id as AnyObject,
//                "mid" : size.manuId as AnyObject,
//                "heading" : "\(item.restItem.heading) (\(size.manuName))" as AnyObject,
//                "qty" : "\(size.itemQty)" as AnyObject,
//                "size" : "\(size.name)" as AnyObject,
//                "price" : "\(size.price)" as AnyObject,
//                "extra" : "\(toppings)" as AnyObject,
//                "extamount" : "\(item.extra)" as AnyObject,
//                "addedInst" : "\(item.instructionText)" as AnyObject,
//                "toppingList": "" as AnyObject
//                ]
            
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: items, options: .prettyPrinted)
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                // here "decoded" is of type `Any`, decoded from JSON data
                
                // you can now cast it with the right type
                if let dictFromJSON = decoded as? [String:AnyObject] {
                    // use dictFromJSON
                    itemArray.append(dictFromJSON)
                    
                }
            }
            catch{
                
            }
        }
        return itemArray
    }
    @objc func deleteAction() {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure want to delete?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Cancel", style: .default) { action in
            
        }
        let cancel = UIAlertAction(title: "Ok", style: .cancel) { alert in
            self.orderAsGift = "No"
            self.recipientPhone = ""
            self.recipientfName = ""
            self.recipientlName = ""
            self.cartTableView.reloadData()

        }
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true,
                         completion:nil)
        }
        
    }
    func checkCardInfo()-> Bool {
        if hideCard() {
            return true
        }
        if selectePaymenType == 0 {
        self.payBy = .Card
        if Cart.shared.cardNumber.count == 0 {
            showAlert(title: "Error", msg: "Please enter card number")
            return false
        }
        if Cart.shared.cardExpiry.count == 0 {
            showAlert(title: "Error", msg: "Please enter card expiry")
            return false
        }
        if Cart.shared.cardCvv.count == 0 {
            showAlert(title: "Error", msg: "Please enter card cvv")
            return false
        }
        if Cart.shared.cardZip.count == 0 {
            showAlert(title: "Error", msg: "Please enter zipcode")
            return false
        }
    }
        if selectePaymenType == 1 {
            self.payBy = .Gift
            if Cart.shared.giftNumber.count == 0 {
              showAlert(title: "Error", msg: "Please enter gift number")
                return false
            }
        }
        return true
    }

    func addOrder() {
        if Cart.shared.orderType == .delivery && Cart.shared.restDetails.restMindelivery > Cart.shared.getAllPriceDeatils().subTotal {
            let alertController = UIAlertController(title: "Add more items", message: "Min order \(UtilsClass.getCurrencySymbol())\(Cart.shared.restDetails.restMindelivery) for delivery", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Add", style: .default) { action in
                let tabbar = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3] as! RestDetailsVC
                self.navigationController?.popToViewController(tabbar, animated: true)

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
        
        if ((Cart.shared.restDetails.openstatus.contains("Closed") || Cart.shared.restDetails.openstatus.contains("closed")) && Cart.shared.orderDate == .ASAP){
            self.showAlert(title: "Alert", msg: "Restaurant is closed for now. Please change your delivery / pickup timing.")
            return
        }
        
        if !self.checkCardInfo() {
            return
        }
        var holddate = "\(Cart.shared.selectedTime.date)"
        var holdTime = "\(Cart.shared.selectedTime.time)"
        if Cart.shared.orderDate == .ASAP {
            holddate = ""
            holdTime = ""
        }
        if Cart.shared.orderType == .pickup {
            let add = UserAdd.init(add1: "", add2: "", city: "", id: "", state: "", street: "", type: "", zip: "")
            Cart.shared.userAddress = add
        }
        var donateAmount = Cart.shared.donateAmount
        if !Cart.shared.isDonate {
            donateAmount = 0.0
        }
        
        let pricedetails: CheckoutPrice = Cart.shared.getAllPriceDeatils()
        var parameters: [String: AnyObject] = [String: AnyObject]()
        parameters["did"] = Cart.shared.orderNumber as AnyObject
        parameters["api_id"] = AppConfig.API_ID as AnyObject
        parameters["api_key"] = AppConfig.OldAPI_KEY  as AnyObject
        parameters["customer_id"] = APPDELEGATE.userResponse?.customer.customer_id as AnyObject
        parameters["restaurant_id"] = Cart.shared.restDetails.id as AnyObject
        parameters["order_type"] = "\(Cart.shared.orderType)".capitalized as AnyObject
        parameters["add1"] = "\(Cart.shared.userAddress.add1)" as AnyObject
        parameters["add2"] = "\(Cart.shared.userAddress.add2)" as AnyObject
        parameters["city"] = "\(Cart.shared.userAddress.city)" as AnyObject
        parameters["state"] = "\(Cart.shared.userAddress.state)" as AnyObject
        parameters["zip"] = "\(Cart.shared.userAddress.zip)" as AnyObject
        parameters["orderat"] = "\(Cart.shared.userAddress.type)" as AnyObject
        parameters["pay_by"] = "\(self.payBy)" as AnyObject
        parameters["coupon"] = "\(pricedetails.couponID)" as AnyObject
        parameters["giftnumber"] = "\(selectePaymenType == 1 ? Cart.shared.giftNumber : "")" as AnyObject
        parameters["cardno"] = "\(selectePaymenType == 0 ? Cart.shared.cardNumber : "")" as AnyObject
        parameters["expiry"] = "\(selectePaymenType == 0 ? Cart.shared.cardExpiry : "")" as AnyObject
        parameters["cvv"] = "\(selectePaymenType == 0 ? Cart.shared.cardCvv : "")" as AnyObject
        parameters["billingzip"] = "\(selectePaymenType == 0 ? Cart.shared.cardZip : "")" as AnyObject
        parameters["cardholder"] = "\(selectePaymenType == 0 ? Cart.shared.cardHolder : "")" as AnyObject
        parameters["addcard"] = "No" as AnyObject
        parameters["newcard"] = "New" as AnyObject
        parameters["holdtime"] = "\(Cart.shared.orderDate == .ASAP ? "No" : "Yes")" as AnyObject
        parameters["holddate"] = "\(holddate) \(holdTime)" as AnyObject
        //parameters["holdtime"] = "\(holdTime)" as AnyObject//yyyy-mm-dd G:i:s
        parameters["total"] = "\(pricedetails.total)" as AnyObject
        parameters["tips"] = "\(Cart.shared.isTips ? "\(Cart.shared.tipsAmount)" : "0.0")" as AnyObject
        parameters["rewards"] = "\(Cart.shared.isReward ? "\(Cart.shared.rewardAmount)" : "0.0")" as AnyObject
        parameters["specialinstruction"] = "\(Cart.shared.specialInstructionText)"  as AnyObject
        parameters["items"] = getitemList() as AnyObject
        parameters["devicetype"] = AppConfig.DeviceType as AnyObject
        parameters["scharge"] = "\(pricedetails.serviceCharge)" as AnyObject
        parameters["menutype"] = "\(Cart.shared.menuType)" as AnyObject//Catering / Menu
        parameters["donate"] = "\(donateAmount)" as AnyObject//Catering / Menu
        parameters["dcharge"] = "\(pricedetails.deliveryCharge)" as AnyObject//Catering / Menu
        parameters["recipientname"] = "\(recipientfName) \(recipientlName)" as AnyObject
        parameters["recipientphone"] = "\(recipientPhone)" as AnyObject
        parameters["orderasGift"] = "\(orderAsGift)" as AnyObject//Yes//No




        
        
        
        print(parameters.json)
        UtilsClass.showProgressHud(view: self.view)
        /*
        Cart.shared.orderNumber = "as! String"
        Cart.shared.supportNumber = "success as! String"
        let vc = self.viewController(viewController: FinalOrderPageVC.self, storyName: StoryName.CartFlow.rawValue) as! FinalOrderPageVC

        self.navigationController?.pushViewController(vc, animated: true)
        */
        
        WebServices.placeOrderService(parameters: parameters, successHandler: { (success) in
            print(success)
            UtilsClass.hideProgressHud(view: self.view)
            Cart.shared.orderNumber = success["id"] as! String
            Cart.shared.supportNumber = success["support"] as! String
            let vc = self.viewController(viewController: FinalOrderPageVC.self, storyName: StoryName.CartFlow.rawValue) as! FinalOrderPageVC

            self.navigationController?.pushViewController(vc, animated: true)

            
         }) { (error) in
             UtilsClass.hideProgressHud(view: self.view)
             //print(error)
             self.showAlert(title: "Error", msg: error)
                      }
        
    }
    func hideCard()-> Bool {
        if Cart.shared.isReward && Cart.shared.getTotalPrice() == 0.0 {
            return true
        } else {
            return false
        }
    }

}

extension ConfirmOrderVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return CellTypeSelected.TotalRowsCount.rawValue
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CellTypeSelected.Donate.rawValue:
            if selectePaymenType == 1 {
                Cart.shared.isDonate = false
                Cart.shared.donateAmount = 0.0
                return 0
            }
            return Cart.shared.restDetails.donatechange == "Yes" ? 1 : 0
        case CellTypeSelected.Payment.rawValue:
            if hideCard() {
                return 1
            }
            return 2
        case CellTypeSelected.Itemdetails.rawValue:
            return 0//Cart.shared.cartData.count
        case CellTypeSelected.Totalprice.rawValue:
            return Cart.shared.cartData.count > 0 ? 1 : 0
        case CellTypeSelected.SendAsGift.rawValue:
            return orderAsGift == "Yes" ? 2 : 1
        case CellTypeSelected.Redeem.rawValue:
            return selectePaymenType == 1 ? 0 : 1

        default:
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case CellTypeSelected.Restname.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantNameTVCell", for: indexPath) as! RestaurantNameTVCell
            cell.updateUI()
            cell.selectionStyle = .none
            return cell
        case CellTypeSelected.Deliveryto.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PickupDeliveryTimeTVCell", for: indexPath) as! PickupDeliveryTimeTVCell
                cell.delegate = self
                cell.updateUI()
                cell.selectionStyle = .none
            return cell
        case CellTypeSelected.Deliveryat.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAtTVCell", for: indexPath) as! DeliveryAtTVCell
            cell.selectionStyle = .none
            var add = ""
            if Cart.shared.orderType == .pickup {
                cell.headingLbl.text = "Pickup From:"
                add = "\(Cart.shared.restDetails.name)\n\(Cart.shared.restDetails.street) \(Cart.shared.restDetails.address), \(Cart.shared.restDetails.city), \(Cart.shared.restDetails.state), \(Cart.shared.restDetails.zip)"
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
            
           
            return cell
        case CellTypeSelected.SendAsGift.rawValue:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AsGiftTVCell", for: indexPath) as! AsGiftTVCell
                cell.selectionStyle = .none
                cell.seperatorView.isHidden = self.orderAsGift == "Yes" ? true : false
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecipientTVCell", for: indexPath) as! RecipientTVCell
                cell.selectionStyle = .none
                cell.updateUI(fullName: "\(self.recipientfName) \(self.recipientlName)", phone: "\(self.recipientPhone)")
                cell.deleteBtn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)

                return cell
            }
        case CellTypeSelected.Special.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialRequestTVCell", for: indexPath) as! SpecialRequestTVCell
            cell.selectionStyle = .none
            return cell
        case CellTypeSelected.Payment.rawValue:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTypeTVCell", for: indexPath) as! PaymentTypeTVCell
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            } else {
                if selectePaymenType == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CardNumberTVCell", for: indexPath) as! CardNumberTVCell
                    cell.selectionStyle = .none
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GiftNumberTVCell", for: indexPath) as! GiftNumberTVCell
                    cell.selectionStyle = .none
                    return cell
                }
            }
            
        case CellTypeSelected.Redeem.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemTVCell", for: indexPath) as! RedeemTVCell
            cell.update(amount: "\(userRewardAmount)")
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case CellTypeSelected.Tips.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsTVCell", for: indexPath) as! TipsTVCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case CellTypeSelected.Donate.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DonateTVCell", for: indexPath) as! DonateTVCell
            cell.updateUI()
            cell.selectionStyle = .none
            return cell
            
        case CellTypeSelected.Itemdetails.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemTVCell", for: indexPath) as! CartItemTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.deleteButton.isHidden = true
            cell.deleteButton.tag = indexPath.row
            cell.updateUI(index: indexPath.row)
            cell.selectionStyle = .none
            return cell
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartPriceDetailsTVCell", for: indexPath) as! CartPriceDetailsTVCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.emptyCartButton.isHidden = true
            cell.delegate = self
            cell.updateUI(isPlaceOrder: true)
            cell.selectionStyle = .none
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == CellTypeSelected.Special.rawValue {
            isSpecialSelected.toggle()
            cartTableView.reloadData()
        }
        if indexPath.section == CellTypeSelected.SendAsGift.rawValue {
            let vc = self.viewController(viewController: AsGiftVC.self, storyName: StoryName.CartFlow.rawValue) as! AsGiftVC
            vc.delegate = self
            vc.fName = recipientfName
            vc.lName = recipientlName
            vc.phone = recipientPhone
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == CellTypeSelected.Donate.rawValue {
            Cart.shared.isDonate.toggle()
            cartTableView.reloadData()
        }
//        let story = UIStoryboard.init(name: "Restaurants", bundle: nil)
//        let vc = story.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == CellTypeSelected.Special.rawValue {
            if isSpecialSelected {
                return 150
            }
            return UIScreen.main.bounds.size.width == 430 ? 60 : 70
        }
        return UITableView.automaticDimension
    }
}
extension ConfirmOrderVC: PaymentTypeDeledate {
    func selectedPaymentType(index: Int) {
        selectePaymenType = index
        cartTableView.reloadData()
    }
}
extension ConfirmOrderVC: TipsDelegate {
    func tipsAction() {
        cartTableView.reloadData()
    }
}

extension ConfirmOrderVC: ChangeTimeDelegate {
    func clickedOnChangeTime() {
        let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ScheduleDateTimeVC") as! ScheduleDateTimeVC
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
}
extension ConfirmOrderVC: ChangeAddressDelegate {
    func changeAddress() {
        /*
        let story = UIStoryboard.init(name: "Profile", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ChooseAddressVC") as! ChooseAddressVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        self.present(popupVC, animated: true)
        */
        self.navigationController?.popViewController(animated: true)
    }
    
    func changePhone() {
        self.navigationController?.popViewController(animated: true)
        /*
        let story = UIStoryboard.init(name: "CartFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ChangePhoneVC") as! ChangePhoneVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        self.present(popupVC, animated: true)
        */
    }
}
extension ConfirmOrderVC: ReloadAddressDelegate {
    func addNewAddress() {
        let vc = self.viewController(viewController: AddAddressVC.self, storyName: StoryName.Profile.rawValue) as! AddAddressVC
        vc.isUpdateAddress = false
        vc.fromCheckoutPage = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changedAddress() {
        cartTableView.reloadData()
    }
    
}
extension ConfirmOrderVC: ReloadNewAddressDelegate {
    func addednewAddress() {
        cartTableView.reloadData()
    }
    
}
extension ConfirmOrderVC: ChangePhoneNumberDelegate {
    func changesNumber() {
        cartTableView.reloadData()
    }
}
extension ConfirmOrderVC: DateChangedDelegate {
    func dateChanged() {
        let address = Cart.shared.userAddress
        if Cart.shared.orderType == .delivery && address == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            cartTableView.reloadData()
        }
    }
}
extension ConfirmOrderVC: CheckoutDelegate {
    func checkoutAction(){
        self.addOrder()
    }
    func emptyAction(){
        
    }
}
extension ConfirmOrderVC: RedeemDelegate {
    func selectedRedeemAction() {
       // if re
        cartTableView.reloadData()
    }
}

extension ConfirmOrderVC: RecipientDetailsDelegate {
    func recipientDetailsSubmitted(fname: String, lname: String, phone: String) {
        recipientfName = fname
        recipientlName = lname
        recipientPhone = phone
        orderAsGift = "Yes"
        
        cartTableView.reloadData()
    }
}

