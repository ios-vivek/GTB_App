//
//  RestaurantVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit

class RestaurantVC: UIViewController {
    @IBOutlet weak var topConstrains: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var userProfileIcon: UIImageView!
    @IBOutlet weak var micSearch: UIImageView!
    @IBOutlet weak var serachImage: UIImageView!
    @IBOutlet weak var serachField: UITextField!
  //  @IBOutlet weak var restaurantTable: UITableView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var restaurationNotAvailableView: UIView!
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var locationButton1: UIButton!
    @IBOutlet weak var locationImageview: UIImageView!
    @IBOutlet weak var animationSearchView: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var searchForLabel: UILabel!

    @IBOutlet weak var homeCollection: UICollectionView!


    //var restData: RestListData?
    var restList = [Restaurant]()
    var topRestList = [Restaurant]()
    var deliciousRestList = [Restaurant]()
    var inspiredRestList = [Restaurant]()
    var cuisineList = [Cuisine]()
    var cuisineHeading = ""
    var restHeading = ""
    var banner = ""
    var sliderList = [RestSlider]()
    var selectedCuisines = -1
    var coupons = [Coupon]()
    var gotResponse = false
    
    var strings = ["\'food\'".translated(), "\'restaurants\'".translated(), "\'groceries\'".translated(), "\'beverages\'".translated(), "\'bread\'".translated(), "\'pizza\'".translated(), "\'biryani\'".translated(), "\'burger\'".translated(), "\'bajji\'".translated(), "\'noodles\'".translated(), "\'soup\'".translated(), "\'sandwich\'".translated(), "\'biscuits\'".translated(), "\'chocolates\'".translated()]

    var index = 1
    var timer: Timer?
    
    override func viewDidLoad() {

        super.viewDidLoad()
//        if #available(iOS 15.0, *) {
//            restaurantTable.sectionHeaderTopPadding = 0.0
//        } else {
//            // Fallback on earlier versions
//        }
      //  LocationManagerClass.shared.getUserLocation()
        //restaurantTable.backgroundColor = .white
        //self.view.backgroundColor = .white
        homeCollection.backgroundColor = .white
        homeCollection.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView") //elementKindSectionFooter for footerview
        
      //  restaurantTable.register(UINib(nibName: "TableHeaderFilterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableHeaderFilterView")
        micSearch.isUserInteractionEnabled = true
        serachField.isUserInteractionEnabled = false
        serachField.text = ""
        serachField.textColor = .gray
        searchView.layer.cornerRadius = 10
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 1
        serachField.backgroundColor = .clear
       
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        searchView.addGestureRecognizer(searchTap)
        let searchTap1 = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        animationSearchView.addGestureRecognizer(searchTap1)
        
        let micTap = UITapGestureRecognizer(target: self, action: #selector(micTapAction(tapGestureRecognizer:)))
        micSearch.addGestureRecognizer(micTap)
        getdata()
        self.getCuisinesFromApi()
        searchForLabel.text = "title4".translated()
    }
    func getdata() {
        self.cuisineList = APPDELEGATE.getCousins()
        self.cuisineHeading = APPDELEGATE.getCusineheading()
        self.banner = APPDELEGATE.getBanner()
        self.sliderList = APPDELEGATE.getSlider()
        self.coupons = APPDELEGATE.getCoupons()
    }
    func themeSet() {
        self.view.backgroundColor = themeBackgrounColor
       // restaurantTable.backgroundColor = themeBackgrounColor
        view1.backgroundColor = themeBackgrounColor
        view2.backgroundColor = themeBackgrounColor
        searchView.backgroundColor = .white
        self.headingLabel.textColor = themeTitleColor
        self.locationButton.setTitleColor(themeTitleColor, for: .normal)
        cartLbl.textColor = themeTitleColor
       // locationButton1.setTitleColor(themeTitleColor, for: .normal)
            //  locationButton1.tintColor = themeTitleColor
        locationImageview.tintColor = themeTitleColor

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkViewHidden()
        cartLbl.text = "\(Cart.shared.cartData.count)"
        themeSet()
        animateListOfLabels()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // print("Invalidate timer")
        timer?.invalidate()
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

    func getRestDataFromApi() {
        var cuisine = ""
        if selectedCuisines >= 0 {
            cuisine = cuisineList[self.selectedCuisines].heading
        }
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "DeviceToken" : AppConfig.DeviceToken as AnyObject,
            "DeviceVersoin" : "1.0" as AnyObject,
            "rest_zip" : "\(APPDELEGATE.selectedLocationAddress.zipcode ?? "")" as AnyObject,
            //"rest_zip" : "01801" as AnyObject,

            "cust_lat" : "\(APPDELEGATE.selectedLocationAddress.latLong.latitude)" as AnyObject,
            "cust_long" : "\(APPDELEGATE.selectedLocationAddress.latLong.longitude)" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
            "cuisine_type" : cuisine as AnyObject,
            "address" : "\(UtilsClass.getFullAddress())" as AnyObject

        ]
        if self.restList.count == 0 {
            UtilsClass.showProgressHud(view: self.view)
        }
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.resturantList, forModelType: RestaurantListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.restList = success.data.restaurant
            self.setAllRestdata()
            self.restHeading = success.data.heading
            self.gotResponse = true
          //  self.restaurantTable.reloadData()
        } ErrorHandler: { error in
            self.gotResponse = true
            UtilsClass.hideProgressHud(view: self.view)
            self.restList = [Restaurant]()
            self.setAllRestdata()
        }
        
    }
    func setAllRestdata() {
        self.topRestList = self.restList
        self.topRestList = self.topRestList.sorted(by: { $0.rating ?? 0.0 > $1.rating ?? 0.0 })
        self.deliciousRestList = self.restList
        self.inspiredRestList = [Restaurant]()
       // print("self.inspiredRestList--\(UtilsClass.getInspairedPast())")
      //  self.restaurantTable.reloadSections(IndexSet(integer: 4), with: .none)
      //  self.restaurantTable.reloadSections(IndexSet(integer: 3), with: .none)
       // self.restaurantTable.reloadRows(at: [IndexPath(row: 0, section: 5)], with: .automatic)
       // self.restaurantTable.reloadData()
        //print("getPastOrdersRest \(UtilsClass.getPastOrdersRest())")
        
        if self.restList.count > 0 {
           let restids = UtilsClass.getPastOrdersRest()
            if restids.count > 0 {
                for restid in restids {
                    if let found = restList.first(where: { $0.id == restid.restId }) {
                        self.inspiredRestList.append(found)
                    } else {
                        print("Not found")
                    }
                }
            }
        }
        
        if self.restList.count > 0 {
           let restids = UtilsClass.getInspairedPast()
            if restids.count > 0 {
                for restid in restids {
                    if let foundr = inspiredRestList.first(where: { $0.id == restid }) {
                        print("already added")
                    } else {
                        if let found = restList.first(where: { $0.id == restid }) {
                                self.inspiredRestList.append(found)
                        } else {
                            print("Not found")
                        }
                    }
                }
            }
        }
        self.homeCollection.reloadData()

    }
    func getCuisinesFromApi() {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject
        ]
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.cuisine, forModelType: CuisineResponse.self) { success in
           // UtilsClass.hideProgressHud(view: self.view)
            self.cuisineList = success.data.cuisine
            APPDELEGATE.cusines = success.data
            self.cuisineHeading = success.data.cuisine_heading
            self.banner = success.data.banner
            self.sliderList = success.data.slider
            self.coupons = success.data.coupon
          //  self.restaurantTable.reloadData()
            self.homeCollection.reloadData()
            UtilsClass.saveCousines()
            
        } ErrorHandler: { error in
            //UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func setFavRestaurant(index: Int) {
        var rest = self.restList[index]
        var tempList = self.restList
        var favStr = OldServiceType.addFavorite
        if rest.favorite == "Yes" {
            favStr = OldServiceType.removeFavorite
        }
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "devicetoken" : AppConfig.DeviceToken as AnyObject,
            "app_version" : "1.0" as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
            "restaurant_id" : rest.id as AnyObject        ]
        print(parameters)
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: favStr, forModelType: FavoriteResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            //let addRemoveFavRestResponse = success.data.result
            if favStr == OldServiceType.addFavorite {
                rest.favorite = "Yes"
            } else {
                rest.favorite = "No"
            }
            tempList.remove(at: index)
            tempList.insert(rest, at: index)
            self.restList = tempList
           // self.restaurantTable.reloadSections(IndexSet(integer: 3), with: .none)
           // self.showAlert(msg: addRemoveFavRestResponse ?? "")
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func setHiddenRestaurant(index: Int) {
        /*
        var tempList = restData?.rest_list.list
        let rest = restData?.rest_list.list[index]
        let favStr = "Add"
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.API_KEY as AnyObject,
            "devicetoken" : AppConfig.DeviceToken as AnyObject,
            "app_version" : "1.0" as AnyObject,
            "service_type" : ServiceType.hiddenRest as AnyObject,
            "devicetype" : AppConfig.DeviceType as AnyObject,
            "customer_id" : "21080312075829" as AnyObject,
            "restaurant_id" : rest?.restaurant_id as AnyObject,
            "hiddenType" : favStr as AnyObject
        ]
        print(parameters)
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadData(parameter: parameters, forModelType: AddRemoveFavRestResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            //let addRemoveFavRestResponse = success.data.result
            tempList?.remove(at: index)
            self.restData?.rest_list.list = tempList!
            self.restaurantTable.reloadData()
            //self.showAlert(msg: addRemoveFavRestResponse ?? "")
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
        */
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationButton.setTitle(LocationManagerClass.shared.firstAddress, for: .normal)
                self.headingLabel.text = LocationManagerClass.shared.secondAddress
                self.checkViewHidden()

        serachField.delegate = self
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapAction(_:)))
        userProfileIcon.addGestureRecognizer(profileTap)
       
        let serachTap = UITapGestureRecognizer(target: self, action: #selector(searchTapAction))
        serachImage.addGestureRecognizer(serachTap)
        getRestDataFromApi()


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
    func stopTimer() {
        timer?.invalidate()
    }
    
    func resumeTimer() {
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
        if index > 0 {
            currentLabel.text = strings[index-1]
            nextLabel.alpha = 0
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateLabels), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateLabels() {
        print("updateLabels--time active")
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
    func getRestDetailFromApi(restid: String) {
        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "rest_id" : restid as AnyObject
        ]
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromService(parameter: parameters, servicename: OldServiceType.restaurantDetail, forModelType: RestDetailResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "RestDetailsVC") as! RestDetailsVC
            vc.restDetailsData = success.data.restaurant
            self.navigationController?.pushViewController(vc, animated: true)
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    func loadJson(filename fileName: String) -> RestDetails? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
               // decoder.keyDecodingStrategy = .convertFromSnakeCase
                let jsonData = try decoder.decode(RestDetailResponse.self, from: data)
                print("success:\(jsonData)")
                return jsonData.restaurant
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return HomeSection.Count.rawValue
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == HomeSection.Banner.rawValue {
//            return self.banner.count > 0 ? 1 : 0
//        }
//        if section == HomeSection.Slider.rawValue {
//            let allCount = sliderList.count + coupons.count
//            return allCount > 0 ? 1 : 0
//        }
//        if section == HomeSection.Cousine.rawValue{
//            return cuisineList.count > 0 ? 1 : 0
//        }
//        if section == HomeSection.DeliciousDeals.rawValue {
//            return deliciousRestList.count > 0 ? 1 : 0
//        }
//        if section == HomeSection.TopPicks.rawValue {
//            return topRestList.count > 0 ? 1 : 0
//        }
//        if section == HomeSection.Norest.rawValue {
//            if gotResponse {
//                return topRestList.count > 0 ? 0 : 1
//            }else{
//                return 0
//            }
//        }
////        guard let list = restData?.rest_list else {
////            return 0
////        }
//        return restList.count > 0 ? restList.count + 1 : 0
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case HomeSection.Banner.rawValue:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardGIfTVCell", for: indexPath) as! DashboardGIfTVCell
//            cell.selectionStyle = .none
//            cell.backgroundColor = .clear
//            cell.updateUI(imageurl: self.banner)
//            return cell
//        case HomeSection.Slider.rawValue:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as! BannerTableViewCell
//                cell.backgroundColor = .white
//                cell.selectionStyle = .none
//            cell.updateUI(slider: sliderList, coupons: coupons)
//                return cell
//        case HomeSection.Cousine.rawValue:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "MindCousinesTVCell", for: indexPath) as! MindCousinesTVCell
//                //cell.updateUI(cousine: restData?.cousine ?? [])
//                cell.selectedCuisines = self.selectedCuisines
//                cell.updateUIOld(cuisine: cuisineList, heading: self.cuisineHeading)
//               // cell.delegate = self
//                cell.selectionStyle = .none
//                cell.backgroundColor = .white
//                return cell
//        case HomeSection.DeliciousDeals.rawValue:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NearYouCell", for: indexPath) as! NearYouCell
//            cell.selectionStyle = .none
//            cell.backgroundColor = .white
//            cell.configDeliciousDeals(restaurants: deliciousRestList)
//           // cell.delegate = self
//            return cell
//        case HomeSection.TopPicks.rawValue:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NearYouCell", for: indexPath) as! NearYouCell
//            cell.selectionStyle = .none
//            cell.backgroundColor = .white
//            cell.configTopPicks(restaurants: topRestList)
//          //  cell.delegate = self
//            return cell
//        case HomeSection.Rest.rawValue:
//            print(indexPath.section)
//            if indexPath.row == 0{
//                let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCountCell", for: indexPath) as! RestaurantCountCell
//                cell.selectionStyle = .none
//                cell.backgroundColor = .white
//                cell.headingTitle.text = self.restHeading//"heading"//restData?.rest_list.heading ?? ""
//                return cell
//            }
//            else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "RestDetailCell", for: indexPath) as! RestDetailCell
//                cell.delegate = self
//                cell.selectionStyle = .none
//                cell.backgroundColor = .white
////                guard let list = restData?.rest_list else {
////                    return cell
////                }
// //               cell.updateUI(index: indexPath.row - 1, restaurant: list.list[indexPath.row - 1])
//                cell.updateUIWithOld(index: indexPath.row - 1, restaurant: restList[indexPath.row - 1])
//
//                return cell
//           }
//        case HomeSection.Norest.rawValue:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NoRestaurantTVCell", for: indexPath) as! NoRestaurantTVCell
//            cell.selectionStyle = .none
//            cell.backgroundColor = .white
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NearYouCell", for: indexPath) as! NearYouCell
//           // cell.selectionStyle = .none
//            cell.backgroundColor = .white
//            return cell
//        }
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case HomeSection.Rest.rawValue:
//            if indexPath.row > 0 {
//                let rest = self.restList[indexPath.row - 1]
//                UtilsClass.saveInspairedPast(restID: rest.id)
//                self.getRestDetailFromApi(restid: rest.id)
//            }
//        default:
//            self.moveToLocationPage()
//            break
//        }
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case HomeSection.Banner.rawValue:
//            return 110
//        case HomeSection.Norest.rawValue:
//            return 270
//        case HomeSection.Slider.rawValue:
//            return 170
//        case HomeSection.Cousine.rawValue:
//                return 250
//        case HomeSection.DeliciousDeals.rawValue:
//            return 280
//        case HomeSection.TopPicks.rawValue:
//            return 280
//
//        case HomeSection.Rest.rawValue:
//             if  indexPath.row == 0{
//                return 50
//            }
//            else if indexPath.section == 1{
//                return 170
//            }
//        default:
//            return 150
//        }
//        return 170
//    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        switch section {
//        case HomeSection.Banner.rawValue:
//            return 0
//        case HomeSection.Slider.rawValue:
//            return 10
//        case HomeSection.Cousine.rawValue:
//            return 0
//        default:
//            return 0
//        }
//    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //print("dd")
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var headingLabel: UILabel!
   

    @IBAction func changeLang(_ sender: Any) {
        moveToLocationPage()
    }
    func moveToLocationPage() {
        let vc = self.viewController(viewController: LocationVC.self, storyName: StoryName.Location.rawValue) as! LocationVC

        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToSearchController(withText: String){
        self.view.endEditing(true)
        let vc = self.viewController(viewController: RestSearchVC.self, storyName: StoryName.Main.rawValue) as! RestSearchVC

        vc.searchtext = withText
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension RestaurantVC: RestCellDelegate {
    func clickedFavAction(index: Int) {
        print("fav\(index)")
        setFavRestaurant(index: index)
    }
    
    func openOptionView(sender: UITapGestureRecognizer, index: Int) {
        
        let point = sender.location(in: self.view)
        let popupVC = self.viewController(viewController: RestaurantPoupVC.self, storyName: StoryName.Main.rawValue) as! RestaurantPoupVC

        let rest = restList[index]
        if rest.isFav {
            popupVC.numberOfItem = 2
            popupVC.textOne = "Show similar restaurants"
            popupVC.textTwo = "Remove from favourites"
            popupVC.textThree = ""
            popupVC.firstImg = UIImage.init(named: "similarIcon")
            popupVC.secondImg = UIImage.init(named: "favorite")
            popupVC.thirdImg = UIImage.init(named: "")
        } else {
            popupVC.numberOfItem = 3
            popupVC.textOne = "Show similar restaurants"
            popupVC.textTwo = "Add to favourites"
            popupVC.textThree = "Hide this restaurant"
            popupVC.firstImg = UIImage.init(named: "similarIcon")
            popupVC.secondImg = UIImage.init(named: "favorite")
            popupVC.thirdImg = UIImage.init(named: "hidden")
        }
        popupVC.restIndex = index
        popupVC.pointY = Float(point.y)
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
         
    }
    
}

extension RestaurantVC: MicSearchDelegate {
    func searchDone(search: String){
        print(search)
        navigateToSearchController(withText: search)
    }
}
extension String {
    func localizeString(string: String) -> String {
        let path = Bundle.main.path(forResource: string, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
extension RestaurantVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigateToSearchController(withText: "")
    }
}
extension RestaurantVC: SelectOptionDelegate {
    func selectedOption(restIndex: Int, index: Int) {
        print("selected index -\(restIndex)-- \(index)")
        if index == 1 {
            let vc = self.viewController(viewController: SimilarRestaurantVC.self, storyName: StoryName.Main.rawValue) as! SimilarRestaurantVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if index == 2 {
            self.setFavRestaurant(index: restIndex)
        }
        if index == 3 {
            self.setHiddenRestaurant(index: restIndex)
        }
    }
}
extension RestaurantVC: CousineDelegate {
    func selectedCuisine(selsectedindex: Int) {
        self.selectedCuisines = selsectedindex
       // self.restaurantTable.reloadSections(IndexSet(integer: 2), with: .none)
        self.getRestDataFromApi()
    }
    
}
extension RestaurantVC: RestSelectedFromHorizontallistDelegate {
    func favSelectedIndex(restID: String, url: String) {
        //self.fav
    }
    
    func selectedIndex(restID: String) {
        UtilsClass.saveInspairedPast(restID: restID)
        self.getRestDetailFromApi(restid: restID)
    }
    
}

extension RestaurantVC: InspiredFromPastDelegate {
//    func favSelectedIndex(restID: String, url: String) {
//        //self.fav
//    }
    
    func pastSlectedIndex(restID: String) {
        UtilsClass.saveInspairedPast(restID: restID)
        self.getRestDetailFromApi(restid: restID)
    }
    
}


extension RestaurantVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}
extension RestaurantVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        10
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.banner.count > 0 ? 1 : 0
        case 1:
            let allCount = sliderList.count + coupons.count
                return allCount > 0 ? 1 : 0
        case 2:
            return cuisineList.count > 0 ? 1 : 0
        case 3:
            return deliciousRestList.count > 0 ? 1 : 0
        case 4:
            return topRestList.count > 0 ? 1 : 0
        case 5:
            return inspiredRestList.count > 0 ? 1 : 0
        case 6:
            return 1
        case 8:
            return self.restList.count > 0 ? 1 : 0
        default:
            return self.restList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerGIFCVCell", for: indexPath as IndexPath) as! BannerGIFCVCell
            cell.backgroundColor = .clear
            cell.updateUI(imageurl: self.banner)
            return cell;

        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerRestCVCell", for: indexPath as IndexPath) as! BannerRestCVCell
                cell.backgroundColor = .white
            cell.updateUI(slider: sliderList, coupons: coupons)
            return cell;

        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestCouponsCVCell", for: indexPath as IndexPath) as! RestCouponsCVCell
            cell.selectedCuisines = self.selectedCuisines
            cell.updateUIOld(cuisine: cuisineList, heading: self.cuisineHeading)
            cell.delegate = self
            cell.backgroundColor = .white
            return cell;
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeliciousDealsCVCell", for: indexPath as IndexPath) as! DeliciousDealsCVCell
            cell.backgroundColor = .white
            cell.configDeliciousDeals(restaurants: deliciousRestList)
            cell.delegate = self
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeliciousDealsCVCell", for: indexPath as IndexPath) as! DeliciousDealsCVCell
            cell.backgroundColor = .white
            cell.configTopPicks(restaurants: deliciousRestList)
            cell.delegate = self
            return cell
        case 5:
            if inspiredRestList.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoRestFoundCVCell", for: indexPath as IndexPath) as! NoRestFoundCVCell
                    return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InspiredFromPastCVCell", for: indexPath as IndexPath) as! InspiredFromPastCVCell
                cell.backgroundColor = .white
                cell.configInspiredFromPast(restaurants: inspiredRestList)
                cell.delegate = self
                return cell
            }
        case 6:
            if restList.count > 0 {
                let titleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCVCell", for: indexPath as IndexPath) as! TitleCVCell
                titleCell.headingTitle.text = "Yalla, Local Restaurants"
                titleCell.backgroundColor = .white
                return titleCell;
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoRestFoundCVCell", for: indexPath as IndexPath) as! NoRestFoundCVCell
                    return cell
            }
        case 7:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestCVCell", for: indexPath as IndexPath) as! HomeRestCVCell

                if restList.count > 0 {
                    cell.updateUIWithOld(index: indexPath.row, restaurant: restList[indexPath.row])
                }
                cell.backgroundColor = .white
                return cell;
        case 8:
            if restList.count > 0 {
                let titleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCVCell", for: indexPath as IndexPath) as! TitleCVCell
                titleCell.headingTitle.text = "Yalla, DineIn Deals"
                titleCell.backgroundColor = .white
                return titleCell;
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoRestFoundCVCell", for: indexPath as IndexPath) as! NoRestFoundCVCell
                    return cell
            }
        case 9:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestCVCell", for: indexPath as IndexPath) as! HomeRestCVCell

                if restList.count > 0 {
                    cell.updateUIWithOld(index: indexPath.row, restaurant: restList[indexPath.row])
                }
                cell.backgroundColor = .white
                return cell;
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestCVCell", for: indexPath as IndexPath) as! HomeRestCVCell
            if restList.count > 0 {
                cell.updateUIWithOld(index: indexPath.row, restaurant: restList[indexPath.row])
            }
            cell.backgroundColor = .white
            return cell;
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 7 {
            let rest = self.restList[indexPath.row]
            UtilsClass.saveInspairedPast(restID: rest.id)
            self.getRestDetailFromApi(restid: rest.id)
        }
        if indexPath.section == 6 && restList.count == 0 {
            self.moveToLocationPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        switch indexPath.section {
        case 0:
            return CGSize(width: width , height: 150)
        case 1:
            return CGSize(width: width , height: 180)
        case 2:
            return CGSize(width: width , height: 250)
        case 3:
            return CGSize(width: width , height: 280)
        case 4:
            return CGSize(width: width , height: 280)
        case 5:
            return CGSize(width: width , height: self.inspiredRestList.count > 0 ? 280 : 5)
        case 6:
            if restList.count > 0 {
                return CGSize(width: width , height: 60)
            } else {
                return CGSize(width: width , height: 300)
            }
        case 7:
            return CGSize(width: width/2 , height: 240)
        case 8:
            if restList.count > 0 {
                return CGSize(width: width , height: 60)
            } else {
                return CGSize(width: width , height: 300)
            }
        case 9:
            return CGSize(width: width/2 , height: 240)
        default:
            return CGSize(width: width/2 , height: 280)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
