//
//  CartData.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/10/24.
//

import Foundation
struct AddedCartItems: Codable {
    var cartRestuarant: RestDetails!
    var cartLists : [CartList]
}
struct CartList: Codable {
    var restItems: [CartRestItemList]
}
struct CartRestItemList: Codable {
    var restItem: RestItemList!
    var restItemSizes = [Sizes]()
    var restItemTopping = [SelectedTopping]()
}

enum OrderType {
    case pickup
    case delivery
}
enum OrderDate {
    case ASAP
    case Today
    case Later
}
struct CartItemList: Codable {
    var restItem: RestItemList!
    var restItemSizes = [Sizes]()
    var restItemTopping = [SelectedTopping]()
    var extra: Float = 0.0
    var instructionText = ""
    var instructionExtraAmount: Float = 0.0
}
struct CheckoutPrice: Codable {
    var subTotal: Float = 0.0
    var discountedSubTotal: Float = 0.0
    var discount: Float = 0.0
    var tax: Float = 0.0
    var total: Float = 0.0
    var con: Float = 0.0
    var couponID = ""
    var serviceCharge: Float = 0.0
    var deliveryCharge: Float = 0.0
}
class Cart {
    static let shared = Cart()
    var tempRestDetails: RestDetails!
    var restDetails: RestDetails!
    var selectedTopping = [SelectedTopping]()
    var itemSizes = [Sizes]()
    var itemData: RestItemList!
    //var allCompleteMealList = [String]()
    var addedCartItems: AddedCartItems!
    var userAddress: UserAdd!
    var alternateNumber = ""
    var giftNumber = ""
    var cardNumber = ""
    var cardCvv = ""
    var cardExpiry = ""
    var cardHolder = ""
    var cardZip = ""
    var orderNumber = ""
    var supportNumber = ""
    var menuType = "Menu" //Catering / Menu
    var tempRestmenu: RestMenu!
    var tempItemData: RestItemList!
    var tempAllRestmenu = [RestMenu]()
    
    
    //var restuarant: RestaurantDetailData!
    var cartData = [CartItemList]()
    var orderType: OrderType = .pickup
    var selectedTime: SeletedTime!
    var orderDate: OrderDate = .ASAP
    var isDonate: Bool = false
    var donateAmount: Float = 0.0
    var isTips: Bool = false
    var isReward: Bool = false
    var rewardAmount: Float = 0.0
    var tipsAmount: Float = 0.0
    var itemExtra: Float = 0.0
    var instructionText = ""
    var specialInstructionText = ""


    init(){
         let seletedTime = SeletedTime.init(date: UtilsClass.getCurrentDateInString(date: Date()), time: "00:00:00", heading: "Pickup today ASAP")
         selectedTime = seletedTime
    }
    func refreshCartData() {
        tempRestDetails = nil
        restDetails = nil
        selectedTopping = [SelectedTopping]()
        itemSizes = [Sizes]()
        itemData = nil
        addedCartItems = nil
        userAddress = nil
        alternateNumber = ""
        giftNumber = ""
        cardNumber = ""
        cardCvv = ""
        cardExpiry = ""
        cardHolder = ""
        cardZip = ""
        orderNumber = ""
        supportNumber = ""
        
        
        cartData = [CartItemList]()
        orderType = .pickup
        selectedTime = SeletedTime.init(date: UtilsClass.getCurrentDateInString(date: Date()), time: "00:00:00", heading: "Pickup today ASAP")
        orderDate = .ASAP
        isDonate = false
        donateAmount = 0.0
        isTips = false
        isReward = false
        rewardAmount  = 0.0
        tipsAmount = 0.0
        itemExtra = 0.0
        instructionText = ""
        specialInstructionText = ""
    }
    func addInCart() {
        Cart.shared.restDetails = self.restDetails
//        if self.itemData.completeMealList.count > 0 {
//            Cart.shared.allCompleteMealList.append(contentsOf: self.itemData.completeMealList)
//        }
       // print(Cart.shared.allCompleteMealList.count)
        let data = CartItemList(restItem: itemData, restItemSizes: itemSizes, restItemTopping: selectedTopping, extra: self.itemExtra, instructionText: self.instructionText, instructionExtraAmount: self.itemExtra)
        Cart.shared.cartData.append(data)
        
        print(Cart.shared.cartData.count)
        
        let oneCartItem = CartRestItemList(restItem: itemData, restItemSizes: itemSizes, restItemTopping: selectedTopping)
        
         
        if addedCartItems != nil && addedCartItems.cartLists.count > 0 {
            let temp = addedCartItems.cartLists
            var isExistItem = false
            //var isExistSize = false
            //var sizeIndex = -1
            //var itemIndex = -1
            if addedCartItems.cartRestuarant.id == self.restDetails.id {
                for (index, item) in temp.enumerated() {
                    for (innerIndex, innerItem) in item.restItems.enumerated() {
                        if innerItem.restItem.id == itemData.id {
                           // sizeIndex = innerIndex
                            //itemIndex = index
                            if innerItem.restItemSizes.first?.name == self.itemSizes.first?.name {
                                isExistItem = true
                                //isExistSize = true
                                addedCartItems.cartLists[index].restItems[innerIndex].restItemSizes = self.itemSizes
                                addedCartItems.cartLists[index].restItems[innerIndex].restItemTopping = self.selectedTopping
                                print("same item updated")
                                break
                            }
                        }
                    }
                }
//                if isExistItem && !isExistSize{
//                    addedCartItems.cartLists[itemIndex].restItems[sizeIndex].
//                    var acartLists = CartList(restItems: [oneCartItem])
//                    let added = AddedCartItems(cartRestuarantID: self.restuarantID, cartLists: [acartLists])
//                    self.addedCartItems = added
//                    print("next item added")
//                }
                if !isExistItem {
                    print("item not in the list")
                    let acartLists = CartList(restItems: [oneCartItem])
                    addedCartItems.cartLists.append(acartLists)
                    print("next item added")
                }

            } else {
                print("restaurant is different")
            }
        } else {
            var acartLists = CartList(restItems: [oneCartItem])
            let added = AddedCartItems(cartRestuarant: self.restDetails, cartLists: [acartLists])
            self.addedCartItems = added
            print("first item added")
        }
        
    }
    func getItemFromCartList(checkitem: ItemList)-> CartRestItemList? {
        var availbleData = false
        if addedCartItems != nil && addedCartItems.cartLists.count > 0 {
            let temp = addedCartItems.cartLists
            if addedCartItems.cartRestuarant.id == self.restDetails.id {
                for (index, item) in temp.enumerated() {
                    for innerItem in item.restItems {
                        print("\(innerItem.restItem.id)")
                        print("new \(checkitem.id)")
                        if innerItem.restItem.id == checkitem.id {
                            availbleData = true
                           // itemSizes = item.restItems[index].restItemSizes
                            selectedTopping = item.restItems[index].restItemTopping
//                            if innerItem.restItemSizes.first?.name == self.itemSizes.first?.name {
//                                addedCartItems.cartLists[index].restItems[innerIndex].restItemSizes = self.itemSizes
//                                addedCartItems.cartLists[index].restItems[innerIndex].restItemTopping = self.selectedTopping
//                                print("same item updated")
                                break
//                            }
                        }
                    }
                }

            }
        }
        var oneCartItem = CartRestItemList(restItem: itemData, restItemSizes: Cart.shared.itemSizes, restItemTopping: selectedTopping)

        if !availbleData {
            oneCartItem = CartRestItemList(restItem: itemData, restItemSizes: [Sizes](), restItemTopping: [SelectedTopping]())
        }
        return oneCartItem
    }

    func addAndRemoveToppins(selectedTopping: SelectedTopping, maxCount: Int) -> String {
        var msg = ""
        if Cart.shared.selectedTopping.count == 0 {
            Cart.shared.selectedTopping.append(selectedTopping)
            return msg
        }
        var isExistTopping = false
        for (index, item) in Cart.shared.selectedTopping.enumerated(){
            if item.toppingHeading == selectedTopping.toppingHeading {
                isExistTopping = true
                var isExistOption = false
                var existOption = Cart.shared.selectedTopping[index].option
                for (opIndex, option) in item.option.enumerated() {
                    if option.optionHeading == selectedTopping.option[0].optionHeading {
                        isExistOption = true
                        existOption.remove(at: opIndex)
                    }
                }
                if !isExistOption {
                    if maxCount == 0 {
                        existOption.append(selectedTopping.option[0])
                    }
                    else if maxCount > existOption.count {
                        existOption.append(selectedTopping.option[0])
                    } else {
                        msg = "You can choose only \(maxCount) option(s)"
                    }
                }
                Cart.shared.selectedTopping[index].option = existOption
            }
        }
        if !isExistTopping {
            Cart.shared.selectedTopping.append(selectedTopping)
        }
      //  print(RestaurantCartDeatils.shared.selectedTopping[0].option)
       // print(RestaurantCartDeatils.shared.selectedTopping.count)
        
        return msg
    }
    func getAllPriceDeatils()-> CheckoutPrice {
        var subTotal: Float = 0.0
        var discountSubtotal: Float = 0.0
        var discount: Float = 0.0
        var tax: Float = 0.0
        var total: Float = 0.0
        var con: Float = 0.0
        var serviceCharge: Float = 0.0
        var couponID = ""
        var deliveryCharge: Float = 0.0
        
        for item in cartData {
            let size = item.restItemSizes.first
            var asubTotal = Float(size!.price)! * Float(size!.itemQty)
            var toppings: Float = 0.0
            for topping in item.restItemTopping {
                for option in topping.option {
                    toppings = toppings + (Float(option.price) * Float(size!.itemQty))
                }
            }
            asubTotal = asubTotal + toppings + item.extra
            subTotal = subTotal + asubTotal
        }
        if Cart.shared.restDetails != nil {
            let discountArray = Cart.shared.restDetails.offer!.sorted { $0.minorder < $1.minorder}
            if discountArray.count > 0 {
                for item in discountArray.enumerated() {
                    if item.element.minorder <= subTotal {
                        if item.element.types == "$" {
                            discount = item.element.amount
                        }
                        if item.element.types == "%" {
                            discount = (subTotal * item.element.amount) / 100
                        }
                        couponID = item.element.id
                    }
                }
                
            }
            if APPDELEGATE.getCoupons().count > 0 {
                for couponItem in APPDELEGATE.getCoupons().enumerated() {
                    let minOrder = Float(couponItem.element.min)
                    let amount = Float(couponItem.element.amount)
                    var isApplyFirst = true
                    if APPDELEGATE.userLoggedIn() {
                        isApplyFirst = APPDELEGATE.userResponse!.customer.orders == 0 ? true : false
                    }
                    if couponItem.element.type == "New" && minOrder! <= subTotal && discount < amount! && isApplyFirst {
                        discount = amount!
                    } else {
                        if couponItem.element.type == "All" && minOrder! <= subTotal && discount < amount! {
                            discount = amount!
                        }
                    }
                }
            }
            discountSubtotal = subTotal - discount
            deliveryCharge = self.calculateDeliveryCharge(discountSubtotal: discountSubtotal)
            
            if Cart.shared.restDetails.serfee == "Yes" {
                serviceCharge = Cart.shared.restDetails.schargemin
                if Float(Cart.shared.restDetails.schargemaxord) <= discountSubtotal {
                    serviceCharge = Float(Cart.shared.restDetails.schargemax)
                }
            }
            
            
            
            serviceCharge = self.roundValue2Digit(value: serviceCharge)
            if Cart.shared.restDetails.gbdelivery == "Yes" {
                con =  (discountSubtotal * Float(Cart.shared.restDetails.gbconv)) / 100
            } else {
                con =  (discountSubtotal * Float(Cart.shared.restDetails.restConv)) / 100
            }
            con = self.roundValue2Digit(value: con)
            tax = (discountSubtotal * Cart.shared.restDetails.restTax) / 100
        }
        tax = self.roundValue2Digit(value: tax)
        var taxCalculation = tax + con + serviceCharge
        taxCalculation = self.roundValue2Digit(value: taxCalculation)
    
        
        total = (subTotal + taxCalculation) - discount
        let price = CheckoutPrice.init(subTotal: subTotal,discountedSubTotal: discountSubtotal, discount: discount, tax: taxCalculation, total: total, con: con, couponID: couponID, serviceCharge: serviceCharge, deliveryCharge: self.roundValue2Digit(value: deliveryCharge))
        return price
    }
    func calculateDeliveryCharge(discountSubtotal: Float) -> Float {
        var tempDeliveryCharge: Float = 0.0
        if Cart.shared.orderType == .delivery {
            if Cart.shared.restDetails.gbdelivery == "Yes" {
                    if Cart.shared.restDetails.dchargetype == "$" {
                        tempDeliveryCharge = Cart.shared.restDetails.gbdcharge
                    } else {
                        tempDeliveryCharge = (discountSubtotal * Cart.shared.restDetails.gbdcharge) / 100
                    }
            } else {
                    if Cart.shared.restDetails.dchargetype == "$" {
                        tempDeliveryCharge = Cart.shared.restDetails.dcharge
                    } else {
                        tempDeliveryCharge = (discountSubtotal * Cart.shared.restDetails.dcharge) / 100
                    }
            }
        }
        return tempDeliveryCharge
    }
    func getTotalPrice()-> Float{
        var paybleAmount: Float = 0.0
        if Cart.shared.restDetails != nil {
            let details = Cart.shared.getAllPriceDeatils()
            paybleAmount = details.total
            if Cart.shared.isTips {
                paybleAmount = details.total + Cart.shared.tipsAmount
                paybleAmount = Cart.shared.roundValue2Digit(value: paybleAmount)
            }
            if Cart.shared.isDonate {
                paybleAmount = details.total + Cart.shared.donateAmount + Cart.shared.tipsAmount
                paybleAmount = Cart.shared.roundValue2Digit(value: paybleAmount)
            }
            
            if Cart.shared.isReward {
                let payValue = paybleAmount - Cart.shared.rewardAmount
                if payValue.isLess(than: 0.0){
                    paybleAmount = 0
                }
            }
        }
        return Cart.shared.roundValue2Digit(value: paybleAmount)
         }
    func roundValue2Digit(value: Float)-> Float {
       // print(value)
        let y = Float(round(100 * value) / 100)
       // print(y)
        return y
    }
    func getOptionsPrice(option: RestOptionList, sizes: Sizes?)-> Float {
        var price: Float = 0.0
        if sizes != nil {
            if sizes!.sizeKey == "sm" {
                if option.sm.count > 0 {
                    price = Float(option.sm) ?? 0.0
                }
            }
            else if sizes!.sizeKey == "md" {
                if option.md.count > 0 {
                    price = Float(option.md) ?? 0.0
                }
            }
            else if sizes!.sizeKey == "lg" {
                if option.lg.count > 0 {
                    price = Float(option.lg) ?? 0.0
                }
            }
            else if sizes!.sizeKey == "ex" {
                if option.ex.count > 0 {
                    price = Float(option.ex) ?? 0.0
                }
            }
            else if sizes!.sizeKey == "xl" {
                if option.lg.count > 0 {
                    price = Float(option.ex) ?? 0.0
                }
            }

        }
        return price
    }
    func getAllSizes(menu: RestMenu, item: RestItemList) -> [Sizes] {
        var arr = [Sizes]()
        if item.sm > 0 {
           // let sprice: Float = item.sm
            arr.append(Sizes.init(manuName: menu.heading, manuId: menu.id, name: "\(menu.sms)", price: "\(item.sm)", itemQty: item.minqty, sizeKey: "sm"))
        }
        if item.md > 0 {
            //let sprice: Float = Float(item.md) ?? 0.0
            arr.append(Sizes.init(manuName: menu.heading, manuId: menu.id, name: "\(menu.mds)", price: "\(item.md)", itemQty: item.minqty, sizeKey: "md"))
        }
        if item.lg > 0 {
           // let sprice: Float = Float(item.lg) ?? 0.0
            arr.append(Sizes.init(manuName: menu.heading, manuId: menu.id, name: "\(menu.lgs)", price: "\(item.lg)", itemQty: item.minqty, sizeKey: "lg"))
        }
        if item.ex > 0 {
           // let sprice: Float = Float(item.ex) ?? 0.0
            arr.append(Sizes.init(manuName: menu.heading, manuId: menu.id, name: "\(menu.sms)", price: "\(item.ex)", itemQty: item.minqty, sizeKey: "ex"))
        }
        if item.xl > 0 {
           // let sprice: Float = Float(item.xl) ?? 0.0
            arr.append(Sizes.init(manuName: menu.heading, manuId: menu.id, name: "\(menu.xls)", price: "\(item.xl)", itemQty: item.minqty, sizeKey: "xl"))
        }
        
        return arr
    }
    func checkMinimumToppins(topping: RestToppingsResponse) -> String {
        var msg = "not required"
        let minimumReq = Int(topping.required) ?? 0
        if minimumReq > 0 {
            let top = selectedTopping.filter({ el in el.toppingHeading == topping.heading })
            if top.count == 0 {
                if top.count < minimumReq {
                    msg = "\(topping.heading) required \(minimumReq) toppings."
                }
            }
            else if top.count > 0 && top.first?.option.count == 0 {
                if top.first!.option.count < minimumReq {
                    msg = "\(topping.heading) required \(minimumReq) toppings."
                }
            }
            else if top.count > 0 && (top.first?.option.count)! > 0{
                let inner = top.first
                if inner!.option.count < minimumReq {
                    msg = "\(topping.heading) required \(minimumReq) toppings."
                }
//                for item in inner!.option {
//                    let opt = top.first!.option.filter({ el in el.optionHeading == topping.heading })
//
//                }
               // let opt: SelectedOption = top.first!.option

            }

            
        }
        return msg
    }
    func isAddedOption(toppingHeading: String, optionHeading: String)-> Bool{
        var isExistOption = false
        for item in Cart.shared.selectedTopping {
                for option in item.option {
                    if item.toppingHeading == toppingHeading && option.optionHeading == optionHeading {
                        isExistOption = true
                    }
                }
        }
        return isExistOption
       
    }
}
extension Float {
    func toString()-> String{
        return String(format: "%.2f", self)
    }
}
