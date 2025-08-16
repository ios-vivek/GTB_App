//
//  ProfileVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit

protocol LoginSuccessDelegate: AnyObject {
    func loginCompleted()
    func signupAction()
}
class ProfileVC: UIViewController {

    @IBOutlet weak var tbl: UITableView!
    weak var delegate: LoginSuccessDelegate?
    let items = ["Profile Details","Favourites","Hidden Restaurant","Address","Reward","Change Password","Logout"]
    var loggedIn = false
    var fromOtherPage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tbl.backgroundColor  = .clear
        checkedForTblScroll()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UtilsClass.getuserDetails()
        guard let user = APPDELEGATE.userResponse else {
            logoutPage()
            return
        }
        loginAction()
    }
    func loginAction() {
        loggedIn = true
        tbl.reloadData()
        checkedForTblScroll()
        self.dismiss(animated: true) {
            self.delegate?.loginCompleted()
        }
    }
    func logoutPage() {
            self.logout()
    }
    func logout() {
        APPDELEGATE.userResponse = nil
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "SavedPerson")
        loggedIn = false
        tbl.reloadData()
        checkedForTblScroll()
    }
    func checkedForTblScroll() {
        tbl.isScrollEnabled = loggedIn ? true : false
    }
    func signInService(email: String, password: String) {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "customer_id" : email as AnyObject,
            "customer_pw" : password as AnyObject
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.getLogin, forModelType: UserResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            APPDELEGATE.userResponse = success.data
            UtilsClass.saveUserDetails()
            self.loginAction()
            
        } ErrorHandler: { error in
            if error == "Invalid User Details" {
                self.showAlert(title: "Error", msg: error)
            } else {
                self.showAlert(title: "Error", msg: "Something went wrong, try again later.")
            }
            UtilsClass.hideProgressHud(view: self.view)
        }
    }

}
extension ProfileVC: EditProfileDelegate {
    func editProfileSelected() {
        let vc = self.viewController(viewController: EditProfileVC.self, storyName: StoryName.Profile.rawValue) as! EditProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ProfileVC: LoginDelegate {
    func forgotActionAction() {
        let story = UIStoryboard.init(name: "Profile", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ForgotVC") as! ForgotVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
    
    func loggedInAction(email: String, password: String) {
        self.signInService(email: email, password: password)
    }
    
    func loginErrorAction(msg: String) {
        self.showAlert(title: "Error", msg: msg)
    }
    
    func signupAction() {
        if fromOtherPage {
            self.dismiss(animated: true) {
                self.delegate?.signupAction()
            }
        } else {
            let vc = self.viewController(viewController: SignupVC.self, storyName: StoryName.Profile.rawValue) as! SignupVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loggedIn {
            return items.count
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loggedIn {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTVCell", for: indexPath) as! UserDetailsTVCell
                cell.selectionStyle = .none
                cell.delegate = self
                cell.backgroundColor = .clear
                cell.updateUI()
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemTVCell", for: indexPath) as! ProfileItemTVCell
          //  cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.itemName.text = items[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            if indexPath.row == items.count - 1 {
                cell.accessoryType = .none
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoginViewTVCell", for: indexPath) as! LoginViewTVCell
          //  cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.delegate = self
            return cell
        }
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            let alertController = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Cancel", style: .default) { action in

            }
            let cancel = UIAlertAction(title: "Ok", style: .cancel) { alert in
                self.logout()
            }
            alertController.addAction(OKAction)
            alertController.addAction(cancel)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
        }
        if indexPath.row == 1 {
            let vc = self.viewController(viewController: FavouritesVC.self, storyName: StoryName.Profile.rawValue) as! FavouritesVC

            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2 {
            let vc = self.viewController(viewController: HiddenRestVC.self, storyName: StoryName.Profile.rawValue) as! HiddenRestVC

            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 3 {
            let vc = self.viewController(viewController: AddressVC.self, storyName: StoryName.Profile.rawValue) as! AddressVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 4 {
            let vc = self.viewController(viewController: RewardVC.self, storyName: StoryName.Profile.rawValue) as! RewardVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 5 {
            let vc = self.viewController(viewController: ChangePasswordVC.self, storyName: StoryName.Profile.rawValue) as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if loggedIn {
            if indexPath.row == 0 {
                return 190
            }
            return 50
        }
        return 745
    }
}
