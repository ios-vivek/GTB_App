//
//  DashBoardVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit
import Alamofire
class DashBoardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topConstrains: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var userProfileIcon: UIImageView!
    @IBOutlet weak var micSearch: UIImageView!
    @IBOutlet weak var serachImage: UIImageView!
    @IBOutlet weak var serachField: UITextField!
    @IBOutlet weak var restaurantTable: UITableView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var restaurationNotAvailableView: UIView!
    @IBOutlet weak var liveitUpView: UIView!
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var animationSearchView: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var searchForLabel: UILabel!

    @IBOutlet weak var imageToConstant: NSLayoutConstraint!
    
@IBOutlet weak var liveItUpImage: UIImageView!
    var strings = ["\'food\'".translated(), "\'restaurants\'".translated(), "\'groceries\'".translated(), "\'beverages\'".translated(), "\'bread\'".translated(), "\'pizza\'".translated(), "\'biryani\'".translated(), "\'burger\'".translated(), "\'bajji\'".translated(), "\'noodles\'".translated(), "\'soup\'".translated(), "\'sandwich\'".translated(), "\'biscuits\'".translated(), "\'chocolates\'".translated()]
    var index = 1
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
      
        if #available(iOS 15.0, *) {
            restaurantTable.sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
        let size = UIScreen.main.bounds.size.width
        if size == 430.0 {
            liveitUpView.frame.size.height = 150
            //restaurantTable.isScrollEnabled = false
            imageToConstant.constant = 0.0
        } else {
            imageToConstant.constant = -40.0
        }
      //  LocationManagerClass.shared.getUserLocation()
        cartLbl.textColor = kOrangeColor
        restaurantTable.backgroundColor = .white

        let url = "https://img1.wsimg.com/isteam/ip/ee445ab6-30e2-4154-ba10-a084ef192630/LiveItUpLogo_Pantone.png"
      //  liveItUpImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: ""))
        AF.request( url,method: .get).response{ response in

          switch response.result {
           case .success(let responseData):
               self.liveItUpImage.image = UIImage(data: responseData!, scale:1)
           case .failure(let error):
               print("error--->",error)
           }
       }
        liveItUpImage.contentMode = .scaleToFill
        self.view.backgroundColor = .white
            restaurantTable.backgroundColor = .white
        restaurantTable.register(UINib(nibName: "TableHeaderFilterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableHeaderFilterView")
       // let micTap = UITapGestureRecognizer(target: self, action: #selector(micTapAction(tapGestureRecognizer:)))
       // micSearch.addGestureRecognizer(micTap)
        micSearch.isUserInteractionEnabled = true
        serachField.isUserInteractionEnabled = false
        serachField.text = ""//"searchTitle".localizeString(string:
        serachField.textColor = .gray
       checkViewHidden()
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        searchView.addGestureRecognizer(searchTap)
        
        let searchTap1 = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        animationSearchView.addGestureRecognizer(searchTap1)
        
        let micTap = UITapGestureRecognizer(target: self, action: #selector(micTapAction(tapGestureRecognizer:)))
        micSearch.addGestureRecognizer(micTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("location"), object: nil)
        
        searchForLabel.text = "title4".translated()

    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        checkViewHidden()
    }

    func checkViewHidden() {
        var premise = APPDELEGATE.selectedLocationAddress.premise
        let local = APPDELEGATE.selectedLocationAddress.subLocality ?? ""
        let city = APPDELEGATE.selectedLocationAddress.city ?? ""
        var mainAdd = ""
        if premise.count > 0 {
            premise = "\(premise), "
        }
        if local.count > 0 {
            mainAdd = "\(premise)\(local), \(city)"
        }
        else if city.count > 0 {
            mainAdd = "\(city)"
        }
        
        self.locationButton.setTitle(mainAdd, for: .normal)
        self.headingLabel.text = "\(APPDELEGATE.selectedLocationAddress.state ?? ""), \(APPDELEGATE.selectedLocationAddress.zipcode ?? "")"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkViewHidden()
        cartLbl.text = "\(Cart.shared.cartData.count)"
        restaurantTable.reloadData()
        animateListOfLabels()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Invalidate timer")
        timer?.invalidate()
    }
    func getCuisinesFromApi() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject
        ]
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.cuisine, forModelType: CuisineResponse.self) { success in
           // UtilsClass.hideProgressHud(view: self.view)
            APPDELEGATE.cusines = success.data
            UtilsClass.saveCousines()
        } ErrorHandler: { error in
            //UtilsClass.hideProgressHud(view: self.view)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManagerClass.shared.completionAddress = {address in
            print("test address clouser is done")
            if address.count > 0{
                let breaksAdd = address.components(separatedBy:", *")
                self.locationButton.setTitle(breaksAdd[0], for: .normal)
                self.headingLabel.text = breaksAdd[1]
                self.checkViewHidden()
            }
        }
        serachField.delegate = self
        searchView.layer.cornerRadius = 10
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 1
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapAction(_:)))
        userProfileIcon.addGestureRecognizer(profileTap)
       // getCuisinesFromApi()

       

    }
    @objc func profileTapAction(_ sender: UITapGestureRecognizer? = nil) {
        let vc = self.viewController(viewController: CartVC.self, storyName: StoryName.CartFlow.rawValue) as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func micTapAction(tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        // handling code
        micAction()
    }
    @objc func searchTapAction() {
        // handling code
        navigateToSearchController(withText: "")
    }
    
    func micAction(){
        let vc = self.viewController(viewController: MicSearchVC.self, storyName: StoryName.Main.rawValue) as! MicSearchVC
       // self.modalPresentationStyle = UIModalPresentationCurrentContext;
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext

        self.present(vc, animated: true);
       
        vc.completion = { searchedText in
                    print("TestClosureClass is done")
            if searchedText.count > 0{
                self.dismiss(animated: true) {
                    self.navigateToSearchController(withText: searchedText)
                }
            }
                }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return 1
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCell", for: indexPath) as! WelcomeCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayFoodTimingTVCell", for: indexPath) as! DisplayFoodTimingTVCell
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
            
        case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodOptionTVCell", for: indexPath) as! FoodOptionTVCell
            cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        return cell
        default:
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodOptionTVCell", for: indexPath) as! FoodOptionTVCell
            cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let story = UIStoryboard.init(name: "Restaurants", bundle: nil)
//        let vc = story.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        }
        if indexPath.section == 1 {
            return 70
        }
        return 400
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeaderFilterView") as! TableHeaderFilterView
//        //headerView.sectionTitleLabel.text = "TableView Heder \(section)"
//        headerView.clickedOnFilter = { text in
//            let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterPageVC") as! FilterPageVC
//            //vc.modalPresentationStyle = .fullScreen
//            popupVC.modalPresentationStyle = .overCurrentContext
//            popupVC.modalTransitionStyle = .crossDissolve
//            self.present(popupVC, animated: true)
//        }
//        return headerView
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("dd")
        self.view.endEditing(true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let yPosition = -( scrollView.contentOffset.y+1)
//       // print(yPosition)
//        if yPosition >= -50{
//            topConstrains.constant = -( scrollView.contentOffset.y+1)
//        }
    }
    

    @IBOutlet weak var headingLabel: UILabel!
   

    @IBAction func changeLang(_ sender: Any) {
        let vc = self.viewController(viewController: LocationVC.self, storyName: StoryName.Location.rawValue) as! LocationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToSearchController(withText: String){
        self.view.endEditing(true)
        let vc = self.viewController(viewController: RestSearchVC.self, storyName: StoryName.Main.rawValue) as! RestSearchVC
        vc.searchtext = withText
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    @objc func textFieldDidChange() {
//        if let text = searchField.text, !text.isEmpty {
//            searchView.isHidden = true
//            stopTimer()
//        } else {
//            searchView.isHidden = false
//            resumeTimer()
//        }
//    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func resumeTimer() {
//        if UtilsClass.getLocalLanuage() == "ar" {
//            strings = arStrings
//        }
        currentLabel.text = strings[index-1]
        timer = Timer.scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(updateLabels),
            userInfo: nil,
            repeats: true
        )
    }
    
    func animateListOfLabels() {
      //  if UtilsClass.getLocalLanuage() == "ar" {
          //  strings = arStrings
      //  }
        currentLabel.text = strings[index-1]
        nextLabel.alpha = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateLabels), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabels() {
        print("updateLabels--time active")
//        if UtilsClass.getLocalLanuage() == "ar" {
//            strings = arStrings
//        }
        if index < strings.count {
            nextLabel.text = strings[index]
            nextLabel.alpha = 0
            nextLabel.transform = CGAffineTransform(translationX: 0, y: searchView.frame.height / 2)
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.currentLabel.alpha = 0
                self.currentLabel.transform = CGAffineTransform(translationX: 0, y: -self.searchView.frame.height / 2)
                self.nextLabel.alpha = 1
                self.nextLabel.transform = .identity
            }, completion: { _ in
                // Swap the labels
                self.currentLabel.text = self.nextLabel.text
                self.currentLabel.alpha = 1
                self.currentLabel.transform = .identity
                
                // Reset next label
                self.nextLabel.alpha = 0
                self.nextLabel.transform = CGAffineTransform(translationX: 0, y: self.searchView.frame.height / 2)
            })
            
            index += 1
        } else {
            // Invalidate the timer once all strings are displayed
           // timer?.invalidate()
            index  = 0
        }
    }
    
    
}
extension DashBoardVC: MicSearchDelegate {
    func searchDone(search: String){
        print(search)
        navigateToSearchController(withText: search)
    }
}
extension DashBoardVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigateToSearchController(withText: "")
    }
}
extension DashBoardVC: DashBoardSectionDelegate {
    func selectedSection(index: Int) {
        if index == 0 {
            self.tabBarController?.selectedIndex = 1
        }
        if index == 1 {
            self.tabBarController?.selectedIndex = 1
        }
        if index == 2 {
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
            //vc.listResponse = success.data.restaurant
            vc.isDineFilter = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
