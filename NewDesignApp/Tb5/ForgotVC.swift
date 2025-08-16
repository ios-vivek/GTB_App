//
//  ForgotVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 12/11/24.
//

import UIKit

class ForgotVC: UIViewController {
    @IBOutlet weak var forgotField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var forgotView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        forgotField.placeholder = "Email/Phone"
        saveButton.setRounded(cornerRadius: 8)
        cancelButton.setRounded(cornerRadius: 8)
        forgotView.layer.cornerRadius = 20
        self.view.backgroundColor = .white
    }
    
    @IBAction func dismissControllerPage() {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func forgotActionAction() {
        forgotPassService(email: forgotField.text!)
    }
    func forgotPassService(email: String) {
        if forgotField.text!.isEmpty {
            self.showAlert(title: "Error", msg: "Please enter Email/Phone")
            return
        }
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "email" : email as AnyObject
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.forgotpass, forModelType: FavoriteResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            if success.data.result == "Success" {
                let alert = UIAlertController(title: "Forgot password", message: success.data.message, preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { ok in
                    self.dismissControllerPage()
                }))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else {
               self.showAlert(title: "Error", msg: success.data.message)
           }
        } ErrorHandler: { error in
            if error == "Invalid  Customer" {
                self.showAlert(title: "Error", msg: error)
            } else {
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
}
