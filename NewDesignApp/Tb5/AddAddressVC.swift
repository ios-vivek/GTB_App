//
//  AddAddressVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 28/10/24.
//

import UIKit
protocol ReloadNewAddressDelegate: AnyObject {
    func addednewAddress()
}
class AddAddressVC: UIViewController {
    @IBOutlet weak var address1TxtFld: UITextField!
    @IBOutlet weak var address2TxtFld: UITextField!
    @IBOutlet weak var cityTxtFld: UITextField!
    @IBOutlet weak var stateTxtFld: UITextField!
    @IBOutlet weak var zipcodeTxtFld: UITextField!
    @IBOutlet weak var addressType: UISegmentedControl!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    weak var delegate: ReloadNewAddressDelegate?

    var selectedAddressType = "Home"
    var isUpdateAddress: Bool = false
    var fromCheckoutPage: Bool = false
    var updateUserAdd: UserAdd?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressType.selectedSegmentTintColor = themeBackgrounColor

        addressType.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        if isUpdateAddress {
            address1TxtFld.text = updateUserAdd?.add1
            address2TxtFld.text = updateUserAdd?.add2
            cityTxtFld.text = updateUserAdd?.city
            stateTxtFld.text = updateUserAdd?.state
            zipcodeTxtFld.text = updateUserAdd?.zip
            if updateUserAdd?.type == "Home" {
                addressType.selectedSegmentIndex = 0
            }
            if updateUserAdd?.type == "Office" {
                addressType.selectedSegmentIndex = 1
            }
            if updateUserAdd?.type == "Other" {
                addressType.selectedSegmentIndex = 2
            }
        }
        headerLbl.text = isUpdateAddress ? "Update Address" : "New Address"
        saveBtn.setFontWithString(text: isUpdateAddress ? "UPDATE" : "SAVE", fontSize: 14)
        self.view.backgroundColor = .white
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        //self.delegate?.selectedPaymentType(index: sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            selectedAddressType = "Home"
        }
        if sender.selectedSegmentIndex == 1 {
            selectedAddressType = "Office"
        }
        if sender.selectedSegmentIndex == 2 {
            selectedAddressType = "Other"
        }
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitAction() {
        if address1TxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter address1.")
            return
        }
        else if address2TxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter address2.")
            return
        }
        else if cityTxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter city.")
            return
        }
        else if stateTxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter state.")
            return
        }
        else if zipcodeTxtFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter zipcode.")
            return
        }
        else {
            if isUpdateAddress {
                self.updateAddressService()
            }else {
                self.addAddressService()
            }
           // self.navigationController?.popViewController(animated: true)
        }
    }
    func addAddressService() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "registervia" : "Register" as AnyObject,
            "add1" : address1TxtFld.text! as AnyObject,
            "add2" : address2TxtFld.text! as AnyObject,
            "city" : cityTxtFld.text! as AnyObject,
            "state" : stateTxtFld.text! as AnyObject,
            "zip" : zipcodeTxtFld.text! as AnyObject,
            "address_type" : selectedAddressType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.addAddress, forModelType: AddedAddressResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let alertController = UIAlertController(title: "Success", message: "Address added successfully.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                if self.fromCheckoutPage {
                    let add = UserAdd(add1: self.address1TxtFld.text!, add2: self.address2TxtFld.text!, city: self.cityTxtFld.text!, id: "123", state: self.stateTxtFld.text!, street: "", type: self.selectedAddressType, zip: self.zipcodeTxtFld.text!)
                    let deliveryZipsArray = Cart.shared.restDetails.deliveryzip.components(separatedBy: ",")
                    if !deliveryZipsArray.contains(self.zipcodeTxtFld.text!) {
                        self.showAlert(title: "Error", msg: "Oops! Out of Delivery Radius, We Deliver Within 4 Miles Radius..")
                        return
                    }
                    Cart.shared.userAddress = add
                    self.delegate?.addednewAddress()
                }
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(OKAction)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
        
            
        } ErrorHandler: { error in
            if error == "Invalid User Details" || error == "Customer already registered" {
                self.showAlert(title: "Error", msg: error)
            } else {
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }

            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func updateAddressService() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "registervia" : "Register" as AnyObject,
            "add1" : address1TxtFld.text! as AnyObject,
            "add2" : address2TxtFld.text! as AnyObject,
            "city" : cityTxtFld.text! as AnyObject,
            "state" : stateTxtFld.text! as AnyObject,
            "zip" : zipcodeTxtFld.text! as AnyObject,
            "address_type" : selectedAddressType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
            "id" : updateUserAdd?.id as AnyObject
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.updateAddress, forModelType: AddedAddressResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let alertController = UIAlertController(title: "Success", message: "Address updated successfully.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(OKAction)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
        
            
        } ErrorHandler: { error in
            if error == "Invalid User Details" || error == "Customer already registered" {
                self.showAlert(title: "Error", msg: error)
            } else {
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }

            UtilsClass.hideProgressHud(view: self.view)
        }
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
