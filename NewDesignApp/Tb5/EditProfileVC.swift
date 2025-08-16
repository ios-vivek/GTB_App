//
//  EditProfileVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 31/08/24.
//

import UIKit

class EditProfileVC: UIViewController {
    @IBOutlet weak var fNameFld: UITextField!
    @IBOutlet weak var sNameFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var phoneFld: UITextField!
    @IBOutlet weak var submitRequestBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        submitRequestBtn.setRounded(cornerRadius: 10)
        submitRequestBtn.setFontWithString(text: "UPDATE", fontSize: 16)
        // Do any additional setup after loading the view.
        fNameFld.text = APPDELEGATE.userResponse?.customer.fname
        sNameFld.text = APPDELEGATE.userResponse?.customer.lname
        emailFld.text = APPDELEGATE.userResponse?.customer.email
        emailFld.textColor = .gray
        phoneFld.text = APPDELEGATE.userResponse?.customer.phone
        self.view.backgroundColor = .white
        fNameFld.backgroundColor = .white
        sNameFld.backgroundColor = .white
        emailFld.backgroundColor = .white
        phoneFld.backgroundColor = .white
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitRequestAction() {
        if fNameFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter first name.")
            return
        }
        else if sNameFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter last name.")
            return
        }
        else if emailFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter email address.")
            return
        }
        else if phoneFld.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter phone number.")
            return
        }
        else {
            self.signUpService()
        }
    }
    func signUpService() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
            "first_name" : fNameFld.text! as AnyObject,
            "last_name" : sNameFld.text! as AnyObject,
            "email" : emailFld.text! as AnyObject,
            "mobile" : phoneFld.text! as AnyObject        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.editProfile, forModelType: UserResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let alertController = UIAlertController(title: "Success", message: "Profile updated successfully.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                APPDELEGATE.userResponse = success.data
                self.navigationController?.popViewController(animated: true)

            }
            alertController.addAction(OKAction)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
        
            
        } ErrorHandler: { error in
            if error == "Details saved successfully" {
                let alertController = UIAlertController(title: "Success", message: "Profile updated successfully.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                    //APPDELEGATE.userResponse = success.data
                    self.navigationController?.popViewController(animated: true)

                }
                alertController.addAction(OKAction)
                OperationQueue.main.addOperation {
                    self.present(alertController, animated: true,
                                 completion:nil)
                }
            } else {
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }
            UtilsClass.hideProgressHud(view: self.view)
        }
    }

}
