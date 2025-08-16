//
//  RestDetailsVC.swift
//  Grabul
//
//  Created by Vivek SIngh on 08/08/24.
//  Copyright © 2024 Omnie. All rights reserved.
// Menu catering Specials Dining

import UIKit
import Lottie

class RestDetailsVC: UIViewController, ItemDetailsDelegate, ItemCellDelegate, ItemAddedInCartDelegate {
    func openSelectSize(index: IndexPath) {
        self.addItemSelection(index: index)
    }
    
    func itemAddedInTheCart() {
        self.showToast(message: "Item added in the cart.", font: .boldSystemFont(ofSize: 14.0))
        cartLbl.text = "\(Cart.shared.cartData.count)"
        cartView.isHidden = Cart.shared.cartData.count > 0 ? false : true
        cartView.updateUI()

    }
    
    func addItemSelection(index: IndexPath) {
        if Cart.shared.restDetails == nil {
            Cart.shared.restDetails = Cart.shared.tempRestDetails
            self.navigateToMenuDetails(index: index)
        }
        else if Cart.shared.restDetails.id != Cart.shared.tempRestDetails.id {
            if Cart.shared.cartData.count > 0 {
                let alertController = UIAlertController(title: "Replace cart item?", message: "Your cart contains dishes from \(Cart.shared.restDetails.name). Do you want to discart the selection and add dishes from \(Cart.shared.tempRestDetails.name)?", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                    Cart.shared.cartData.removeAll()
                    Cart.shared.restDetails = Cart.shared.tempRestDetails
                    self.navigateToMenuDetails(index: index)
                    
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
                self.navigateToMenuDetails(index: index)
            }
                }
        else {
            Cart.shared.restDetails = Cart.shared.tempRestDetails
            self.navigateToMenuDetails(index: index)
        }
    }
    
    func itemClosed() {
        closedPopup()
    }
    
    @IBOutlet weak var restaurantTable: UITableView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var menuHeadingCollection: UICollectionView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var userProfileIcon: UIImageView!
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var menuImageView: LottieAnimationView!
    @IBOutlet weak var allBtn: UIButton!

    var cartView: CartView!
    var isOpen = false
    var restDetailsData: RestDetails?
    var menuList = [RestMenu]()
    var allMenuList = [RestMenu]()
    var allCateringList = [RestInnerMenu]()
    var filteredCateringList = [RestInnerMenu]()
    var specialList = [RestMenu]()
    var selectedmenuType = 0
    var itemData: RestItemList!
    var isReservationAvailable = false
    var selectedFiler = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        if restDetailsData != nil && Cart.shared.tempRestDetails != nil {
            if (restDetailsData!.id != Cart.shared.tempRestDetails.id) {
                let seletedTime = SeletedTime.init(date: UtilsClass.getCurrentDateInString(date: Date()), time: "00:00:00", heading: "Pickup today ASAP")
                Cart.shared.selectedTime = seletedTime
                Cart.shared.orderDate = .ASAP
            }
        }
        Cart.shared.tempRestDetails = restDetailsData!

        if restDetailsData!.ordertypes.contains("Reservation") {
            isReservationAvailable = true
        }
        menuImageView.play()
        menuImageView.loopMode = .loop
        navView.backgroundColor = themeBackgrounColor
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapAction(_:)))
        userProfileIcon.addGestureRecognizer(profileTap)
        cartView = CartView(frame: CGRect(x: 0, y: self.view.frame.size.height - 70, width: self.view.frame.size.width, height: 70))
        self.view.addSubview(cartView)
        cartView.isHidden = true
        menuView.isHidden = true
        restaurantName.isHidden = true
        restaurantName.text = "\(restDetailsData?.name ?? "")"
        restaurantTable.register(UINib(nibName: "ItemHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ItemHeaderView")
        restaurantTable.sectionHeaderTopPadding = 0
        menuView.backgroundColor = .gGray100
        menuHeadingCollection.backgroundColor = .clear
        cartView.delegate = self
        self.view.backgroundColor = themeBackgrounColor
        restaurantTable.backgroundColor = .white
        restaurantName.textColor = .white
        themeSet()
        self.setDefaultBack()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // print("Invalidate timer")
        APPDELEGATE.timr.invalidate()
    }
    func themeSet() {
        cartLbl.textColor = themeTitleColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartLbl.text = "\(Cart.shared.cartData.count)"
        self.allMenuList = [RestMenu]()
        allCateringList = [RestInnerMenu]()
        
        if let meuList = self.restDetailsData?.menu {
            for element in meuList {
                //print("----element.submenu--\(element.submenu)")
                if element.submenu == "No" {
                    if (element.heading == "catering" || element.heading == "Catering") || element.heading == "Quick Meals" {
                        /*
                       // self.cateringList.append(element)
                        allCateringList.append(menu)
                        */
                    } else {
                        self.allMenuList.append(element)
                    }
                } else{
                    var itemlist = [RestItemList]()
                    
                    for menuItem in element.menulist2! {
                        if element.heading == "catering" || element.heading == "Catering" {
                            allCateringList.append(menuItem)
                        }
                       // itemlist.append(headerList)
                        itemlist.append(contentsOf: menuItem.itemList!)
                        
                    }
                    let menu = RestMenu.init(id: element.id, heading: element.heading, url: element.url, sms: element.sms, mds: element.mds, lgs: element.lgs, exs: element.exs, xls: element.xls, submenu: element.submenu, itemList2: itemlist, menulist2: [RestInnerMenu]())
                    if element.heading == "catering" || element.heading == "Catering" {
                        //self.cateringList.append(menu)
                        //self.allMenuList.append(menu)
                    } else {
                        self.allMenuList.append(menu)
                    }
                }
            }
        }
        let arr: [RestMenu] = self.restDetailsData!.menu.filter{ ($0.heading.contains("Quick Meals")) }
        if arr.count > 0 {
            specialList = arr
        }
       // print("cateringList- \(self.allCateringList.count)")
       // print("cateringList- \(self.allCateringList)")
        
        cartView.isHidden = Cart.shared.cartData.count > 0 ? false : true
        getMenuList()
        setImages()
        restaurantTable.reloadData()

    }
    func setImages() {
        if self.restDetailsData!.restImage != "" && self.restDetailsData!.gallery.list.isEmpty {
            let url = ImageURL.init(url: self.restDetailsData!.restImage)
            self.restDetailsData!.gallery.list.append(url)
        }
//                if self.restDetailsData!?.gallery.list.count == 0 {
    }
    func getMenuList() {
        if selectedmenuType == 0 {
            getMenusData()
        }
        if selectedmenuType == 1 {
            self.getCateringData()
        }
        else {
            
        }
        menuHeadingCollection.reloadData()
        restaurantTable.reloadData()
    }
    func getMenusData(){
        menuList = allMenuList
        if selectedFiler >= 0 {
            let arr: [RestMenu] = self.allMenuList.filter{ ($0.heading.contains(allMenuList[selectedFiler].heading)) }
            if arr.count > 0 {
                menuList = arr
            }
        }
    
    }
    func getCateringData() {
        filteredCateringList = allCateringList
        if selectedFiler >= 0 {
            let arr: [RestInnerMenu] = self.allCateringList.filter{ ($0.heading.contains(self.allCateringList[selectedFiler].heading)) }
            if arr.count > 0 {
                filteredCateringList = arr
            }
        }
        
    }
    @IBAction func allBtnAction() {
        selectedFiler = -1
        self.getMenuList()
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func showMenuOption()-> Bool {
        if selectedmenuType == 2 || selectedmenuType == 3 {
            return false
        }
        if selectedmenuType == 1 {
            return filteredCateringList.count > 0 ? true : false
        }
        return true
    }
    func navigateToMenuDetails(index: IndexPath) {
        let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ItemSizeSelectionPopupVC") as! ItemSizeSelectionPopupVC
        if selectedmenuType == 0 {
            let itemList = self.menuList[index.section - 5]
            let itemm = itemList.itemList2?[index.row]
            if let item  = itemm {
                if item.details == "InnerHeading" {
                    return
                }
                itemData = item
            }
        } else if selectedmenuType == 1 {
            let itemList = self.filteredCateringList[index.section - 5]
            let itemm: RestItemList = itemList.itemList![index.row]
                itemData = itemm
        }
        
        popupVC.delegate = self
        popupVC.itemData = self.itemData
        popupVC.restmenu = self.menuList[index.section - 5]
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
        
    }
    func openItemDetails(itemlist: RestItemList, index: IndexPath) {
        if(!isOpen)

           {
               isOpen = true
           var itemsizes = ""
            for item in Cart.shared.getAllSizes(menu: self.menuList[index.section - 5], item: itemData) {
                if itemsizes .isEmpty {
                    itemsizes = "\(item.name) $\(item.price)"
                } else {
                    itemsizes = itemsizes + ", \(item.name) $\(item.price)"
                }
            }
            print("Cart.shared.itemSizes \(itemsizes)")
            let menuVC = self.viewController(viewController: ItemDetailsVC.self, storyName: StoryName.Main.rawValue) as! ItemDetailsVC
            menuVC.itemData = itemlist
            menuVC.index = index
            menuVC.allSizesWithPrice = itemsizes
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //print("dd")
        self.view.endEditing(true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let _ = scrollView as? UITableView {
            let yPosition = -( scrollView.contentOffset.y+1)
           // print(yPosition)
//            if self.restDetailsData?.menutype[selectedmenuType] != "Specials" {
                menuView.isHidden = yPosition >= -577 ? true : false
//            }
            restaurantName.isHidden = yPosition >= -177 ? true : false
            } else if let _ = scrollView as? UICollectionView {
              print("collectionview")
            }
       
    }
    @objc func profileTapAction(_ sender: UITapGestureRecognizer? = nil) {
        let vc = self.viewController(viewController: CartVC.self, storyName: StoryName.CartFlow.rawValue) as! CartVC
       // vc.suggestedItemList = self.allCateringList
        //vc.allMenuList = allMenuList
        Cart.shared.tempAllRestmenu = self.allMenuList
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension RestDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        /*
        if self.restDetailsData?.menutype[selectedmenuType] == "Specials" {
            return RestaurentDetailsSection.Items.rawValue + 1
        }
        let itemListCount = self.menuList.count//self.restDetailsData?.menulist?.count ?? 0
        return RestaurentDetailsSection.Items.rawValue + itemListCount
        */
        if selectedmenuType == 0 {
            return RestaurentDetailsSection.Items.rawValue + menuList.count
        }
        if selectedmenuType == 2 {
            let count = specialList.count > 0 ? specialList.count : 1
            return RestaurentDetailsSection.Items.rawValue + count
        }
        if selectedmenuType == 3 {
            return RestaurentDetailsSection.Items.rawValue + 1
        }
        if selectedmenuType == 1 {
            let count = filteredCateringList.count > 0 ? filteredCateringList.count : 1
            return RestaurentDetailsSection.Items.rawValue + count
        }
        
        return RestaurentDetailsSection.Items.rawValue + menuList.count
        //return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        if section >= RestaurentDetailsSection.Items.rawValue {
            if self.restDetailsData?.menutype[selectedmenuType] == "Specials" {
                return self.bogoItemlist.count
            }else{
                return self.menuList[section - 5].itemlist?.count ?? 0
            }
        }
        if section == RestaurentDetailsSection.Menu.rawValue && self.restDetailsData?.menutype[selectedmenuType] == "Specials" {
            return 0
        }
*/
        if section == RestaurentDetailsSection.Menu.rawValue {
            return self.showMenuOption() ? 1 : 0
        }
        if section == RestaurentDetailsSection.FoodType.rawValue {
            return 1//self.restDetailsData?.offer?.count ?? 0 > 0 ? 1 : 0
        }
        if section == RestaurentDetailsSection.Deals.rawValue {
            return self.restDetailsData?.offer?.count ?? 0 > 0 ? 1 : 0
        }
        if section == RestaurentDetailsSection.Featured.rawValue {
                return 0
        }
        if section >= RestaurentDetailsSection.Items.rawValue {
            if selectedmenuType == 3 {
                return 1
            }
            if selectedmenuType == 2 {
                return specialList.count > 0 ? (specialList[section - 5].itemList2?.count ?? 0) : 1
            }
            if selectedmenuType == 1 {
                let count = filteredCateringList.count > 0 ? (self.filteredCateringList[section - 5].itemList?.count ?? 0) : 1
                return count//self.cateringList[section - 5].itemList2?.count ?? 0
            }
            return self.menuList[section - 5].itemList2?.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case RestaurentDetailsSection.RestDetails.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestDetailTVCell", for: indexPath) as! RestDetailTVCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.updateUI(data: self.restDetailsData)
            return cell
        case RestaurentDetailsSection.Deals.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealsTVCell", for: indexPath) as! DealsTVCell
            cell.selectionStyle = .none
            //cell.backgroundColor = .red
            cell.updateUI(offer: self.restDetailsData?.offer ?? [RestOffer]())
            return cell
        case RestaurentDetailsSection.Featured.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedTVCell", for: indexPath) as! FeaturedTVCell
            cell.selectionStyle = .none
         //   cell.updateUI(featuredItems: self.restDetailsData?.featured_item)
            return cell
        case RestaurentDetailsSection.FoodType.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTypeTVCell", for: indexPath) as! FoodTypeTVCell
            cell.selectionStyle = .none
            //cell.backgroundColor = .green
            cell.delegate = self
            cell.updateUI(menuType: ["Menu", "Catering", "Specials", "Dining"], selectedMenu: selectedmenuType)
            return cell
        case RestaurentDetailsSection.Menu.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodMenuTVCell", for: indexPath) as! FoodMenuTVCell
            cell.selectionStyle = .none
            cell.delegate = self
            if selectedmenuType == 1 {
                cell.updateCategoryUI(restItemList: self.allCateringList, selectedmenuType: selectedmenuType, selectedFiler: self.selectedFiler)
            }else{
                cell.updateUI(menulist: self.allMenuList, selectedmenuType: selectedmenuType, selectedFiler: self.selectedFiler)
            }
            return cell
        //case RestaurentDetailsSection.Items.rawValue:
        default:
            if RestaurentDetailsSection.Items.rawValue >= 0 {
                if selectedmenuType == 2 {
                    if specialList.count == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataAvailableTVCell", for: indexPath) as! NoDataAvailableTVCell
                        cell.selectionStyle = .none
                        cell.updateUI(msg: "No Quick Meals Available order from Regular Menu")
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTVCell", for: indexPath) as! ItemTVCell
                        let item = self.specialList[indexPath.section - 5].itemList2![indexPath.row]
                        cell.selectionStyle = .none
                        cell.delegate = self
                        cell.selectedIndex = indexPath
                            cell.updateUI(itemlist: item)
                        cell.dividerImage.isHidden = false
                        if indexPath.row + 1 == self.menuList[indexPath.section - 5].itemList2?.count {
                            cell.dividerImage.isHidden = true
                        }
                        return cell
                    }
                }

                if selectedmenuType == 3 && !isReservationAvailable{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataAvailableTVCell", for: indexPath) as! NoDataAvailableTVCell
                        cell.selectionStyle = .none
                        cell.updateUI(msg: "Does not take Reservations.")
                        return cell
                }
                if selectedmenuType == 1 {
                    if filteredCateringList.count == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataAvailableTVCell", for: indexPath) as! NoDataAvailableTVCell
                        cell.selectionStyle = .none
                        cell.updateUI(msg: "No Catering Available order from Regular menu")
                        return cell
                    }
                  let item = self.filteredCateringList[indexPath.section - 5].itemList![indexPath.row]
//                    if item.details == "InnerHeading" {
//                        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemHeadingTVCell", for: indexPath) as! ItemHeadingTVCell
//                        cell.selectionStyle = .none
//                        cell.itemHeadingLbl.text = item.heading
//                        cell.backgroundColor = .gGray100
//                        return cell
//                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTVCell", for: indexPath) as! ItemTVCell
                        cell.selectionStyle = .none
                        cell.delegate = self
                        cell.selectedIndex = indexPath
                            cell.updateUI(itemlist: item)
                        cell.dividerImage.isHidden = false
                        if indexPath.row + 1 == self.filteredCateringList[indexPath.section - 5].itemList?.count {
                            cell.dividerImage.isHidden = true
                        }
                        return cell
                    //}
                } else {
                    let item = self.menuList[indexPath.section - 5].itemList2![indexPath.row]
                    if item.details == "InnerHeading" {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemHeadingTVCell", for: indexPath) as! ItemHeadingTVCell
                        cell.selectionStyle = .none
                        cell.itemHeadingLbl.text = item.heading
                        cell.backgroundColor = .gGray100
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTVCell", for: indexPath) as! ItemTVCell
                        cell.selectionStyle = .none
                        cell.delegate = self
                        cell.selectedIndex = indexPath
                            cell.updateUI(itemlist: item)
                        cell.dividerImage.isHidden = false
                        if indexPath.row + 1 == self.menuList[indexPath.section - 5].itemList2?.count {
                            cell.dividerImage.isHidden = true
                        }
                        return cell
                    }
                }
           
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemHeadingTVCell", for: indexPath) as! ItemHeadingTVCell
            cell.selectionStyle = .none
           // cell.delegate = self
           // cell.backgroundColor = .blue
            //cell.updateUI()
            return cell
        }
       
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "vivek"
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section >= RestaurentDetailsSection.Items.rawValue {
            if selectedmenuType == 2 || selectedmenuType == 3 {
                return 0
            }
            if selectedmenuType == 1 {
//                let sec = section - 5
//                let item = self.cateringList[sec].heading
//                if item == "InnerHeading" {
//                    return 0
//                }
                return self.filteredCateringList.count > 0 ? 50 : 0
            }
            return 50
    }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section >= RestaurentDetailsSection.Items.rawValue {
            print(section)
            print(menuList.count)
            let sec = section - 5
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ItemHeaderView") as! ItemHeaderView
//            if self.restDetailsData?.menutype[selectedmenuType] == "Specials" {
//                return nil
//            }
            if selectedmenuType == 1 {
                //print(self.cateringList[sec].heading)
                if self.filteredCateringList.count > 0 {
                    headerView.headingLbl.text = self.filteredCateringList[sec].heading
                    headerView.headingLbl.textColor = .black
                }
                return headerView
            }
            if selectedmenuType == 2 {
                headerView.headingLbl.text = ""
            }
            else {
                headerView.headingLbl.text = self.menuList[sec].heading
            }
           // headerView.headingLbl.textColor = .black

            headerView.headingLbl.textColor = self.menuList[sec].submenu == "No" ? .black : .gSkyBlue
            headerView.headerViewBckground.backgroundColor = UIColor.gGray100
            

            return headerView
    }
        return nil
    
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section >= RestaurentDetailsSection.Items.rawValue {
            self.addItemSelection(index: indexPath)
            /*
            if selectedmenuType == 3 {
                return
            }
            if selectedmenuType == 1 {
                if self.filteredCateringList.count == 0 {
                    return
                }
                let itemList = self.filteredCateringList[indexPath.section - 5]
                let itemm = itemList.itemList?[indexPath.row]
                if let item  = itemm {
                    if item.details == "InnerHeading" {
                        return
                    }
                    itemData = item
                    self.openItemDetails(itemlist: item, index: indexPath)
                }
                
            } else {
                let itemList = self.menuList[indexPath.section - 5]
                let itemm = itemList.itemList2?[indexPath.row]
                if let item  = itemm {
                    if item.details == "InnerHeading" {
                        return
                    }
                    itemData = item
                    self.openItemDetails(itemlist: item, index: indexPath)
                }
            }
            */
        }
        
        /*
        if indexPath.section >= RestaurentDetailsSection.Items.rawValue {
            if self.restDetailsData?.menutype[selectedmenuType] == "Specials" {
                let item = bogoItemlist[indexPath.row]
                itemData = item
                    self.openItemDetails(itemlist: item)
                }
            else{
                let itemList = self.menuList[indexPath.section - 5]
                let itemm = itemList.itemlist?[indexPath.row]
                if let item  = itemm {
                    if item.details == "InnerHeading" {
                        return
                    }
                    itemData = item
                    self.openItemDetails(itemlist: item)
                }
            }
            }
         */
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case RestaurentDetailsSection.RestDetails.rawValue:
            return 275
        case RestaurentDetailsSection.Deals.rawValue:
            return 70
        case RestaurentDetailsSection.Featured.rawValue:
            return 150
        case RestaurentDetailsSection.FoodType.rawValue:
            return 50
        case RestaurentDetailsSection.Menu.rawValue:
            return 50
        default:
            
            if indexPath.section >= RestaurentDetailsSection.Items.rawValue {
                if selectedmenuType == 3 {
                    return 100
                }
                if selectedmenuType == 2 {
                    return specialList.count == 0 ? 100 : 200
                }
                if selectedmenuType == 1 {
                    if filteredCateringList.count == 0 {
                        return 100
                    }
                    let item = self.filteredCateringList[indexPath.section - 5].itemList![indexPath.row]
                    if item.details == "InnerHeading" {
                        return 50
                    }
                } else {
                    let item = self.menuList[indexPath.section - 5].itemList2![indexPath.row]
                    if item.details == "InnerHeading" {
                        return 50
                    }
                }
                return 200
            }
            
            return 200
        }
    }
        
}
extension RestDetailsVC: GalleryDelegate {
    func scheduleDateAction() {
        let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
        let popupVC = story.instantiateViewController(withIdentifier: "ScheduleDateTimeVC") as! ScheduleDateTimeVC
        popupVC.delegate = self
        popupVC.isPickupDeliverySettingHide = true
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)

    }
    
    func selectedGalleryView() {
        let vc = self.viewController(viewController: RestImageGalleryVC.self, storyName: StoryName.Main.rawValue) as! RestImageGalleryVC
//        if self.restDetailsData?.gallery.list.count == 0 {
//            Gallery.init(heading: "No Images Found").list
//        }
        vc.galleryImages = self.restDetailsData?.gallery
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension RestDetailsVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: collectionView.frame.height)
    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        switch kind {
//
//        case UICollectionView.elementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionView", for: indexPath)
//            return headerView
//
//
//
//
//        default:
//            assert(false, "Unexpected element kind")
//        }
//    }
}
extension RestDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        if selectedmenuType == 1 {
//            return cateringList.count
//        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedmenuType == 1 {
            return self.allCateringList.count
        }
        return self.allMenuList.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodMenuCVCell", for: indexPath as IndexPath) as! FoodMenuCVCell
        cell.backgroundColor = .white
        if selectedmenuType == 1 {
            cell.menu.text = self.allCateringList[indexPath.row].heading
            cell.menu.textColor = selectedFiler == indexPath.row ? themeBackgrounColor : .black
        }else{
            cell.menu.text = self.allMenuList[indexPath.row].heading
            cell.menu.textColor = selectedFiler == indexPath.row ? themeBackgrounColor : .black
        }
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.clear.cgColor
        return cell;

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFiler = indexPath.row
//        if selectedmenuType == 1 {
//            return
//        }
        self.getMenuList()
       // self.restaurantTable.scrollToRow(at: IndexPath(row: 0, section: section + 5), at: .middle, animated: true)
        //self.collectionView.scrollToItem(at:IndexPath(item: indexNumber, section: sectionNumber), at: .right, animated: false)

    }
    
    
    
}
extension RestDetailsVC: MenuSelectedDelegate {
    func showAllData() {
        selectedFiler = -1
        self.getMenuList()
    }
    
    func openmenuItemSection(section: Int) {
        selectedFiler = section

//        if selectedmenuType == 1 {
//            return
//        }
        //self.restaurantTable.scrollToRow(at: IndexPath(row: 0, section: section + 5), at: .middle, animated: true)
        self.getMenuList()
        if selectedFiler >= 0 {
            self.menuHeadingCollection.scrollToItem(at:IndexPath(item: selectedFiler, section: 0), at: .right, animated: false)
        }

    }
}
extension RestDetailsVC: MenuTypeSelectedDelegate {
    func selectedMenuType(menuType: Int) {
        selectedFiler = -1
        self.selectedmenuType = menuType
        self.getMenuList()
        restaurantTable.reloadData()
        menuHeadingCollection.reloadData()
        if menuType == 3 && isReservationAvailable {
            let story = UIStoryboard.init(name: "OrderFlow", bundle: nil)
            let popupVC = story.instantiateViewController(withIdentifier: "DineInVC") as! DineInVC
           // popupVC.modalPresentationStyle = .overCurrentContext
           // popupVC.modalTransitionStyle = .crossDissolve
           // popupVC.delegate = self
          //  self.present(popupVC, animated: true)
            self.selectedmenuType = 0
            self.restaurantTable.reloadData()
            self.navigationController?.pushViewController(popupVC, animated: true)
        }
    }
}
extension RestDetailsVC: OpenCartViewDelegate {
    func openCartView() {
        let vc = self.viewController(viewController: CartVC.self, storyName: StoryName.CartFlow.rawValue) as! CartVC
       // vc.suggestedItemList = self.allCateringList
       // vc.allMenuList = self.allMenuList
        Cart.shared.tempAllRestmenu = self.allMenuList
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension RestDetailsVC: DateChangedDelegate {
    func dateChanged() {
        restaurantTable.reloadData()
    }
    
}
