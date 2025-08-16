//
//  RestDetailResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/11/24.
//

import Foundation
struct RestDetailResponse: Codable {
    var restaurant: RestDetails
}
struct RestDetails: Codable {
    let id: String
    let name: String
    var gallery: Gallery
    let phone: String
    let street: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let deliveryzip: String
    let paybycash: String
    let paybycard: String
    let pickuptips: String
    let tax: Float
    let conv: Float
    let dchargetype: String
    let dcharge: Float
    let gbdelivery: String
    let gbdcharge: Float
    let gbconv: Float
    let mindelivery: Float
    let deliverymiles: Float
    let deliverytime: Float
    let pickuptime: Float
    let budget: Float
    let details: String
    let stopyoday: String
    let openstatus: String
    let status: String
    let cuisine: String
    let ordertypes: String
    let img: String
    let imgurl: String
    let rating: Float?
    let Pickup: String
    let Delivery: String
    let rating_hd1: String
    let rating_hd2: String
    let menu: [RestMenu]
    let offer: [RestOffer]?
    let dineTime: [DineTime]
    let donatechange: String
    let donateheading: String
    let donatetext: String
    let schargemin: Float
    let schargemax: Float
    let schargemaxord: Float
    let extracharge: Float
    let serfee: String
    let completeMealList: [String]
    var isRestaurantOpen: Bool {
        if self.openstatus == "Open Now" {
            return true
        }
        return false
    }
    var restImage: String {
        return self.imgurl + self.img
    }
    var isDelivery: Bool {
        return self.ordertypes.contains("Delivery")
    }
    var isPickup: Bool {
        return self.ordertypes.contains("Pickup")
    }
    var restPickupTime: Float {
        return self.pickuptime//self.pickuptime.count > 0 ? (Int(pickuptime) ?? 0) : 0
    }
    var restMindelivery: Float {
        return self.mindelivery//self.mindelivery.count > 0 ? (Int(mindelivery) ?? 0) : 0
    }
    var restConv: Float {
        return self.conv//self.conv.count > 0 ? (Float(conv) ?? 0.0) : 0.0
    }
    
    var restTax: Float {
        return Float(self.tax)//self.tax.count > 0 ? (Float(tax) ?? 0.0) : 0.0
    }
}
struct RestMenu: Codable {
    let id: String
    let heading: String
    let url: String
    let sms: String
    let mds: String
    let lgs: String
    let exs: String
    let xls: String
    let submenu: String
    let itemList2: [RestItemList]?
    let menulist2: [RestInnerMenu]?
}
struct RestInnerMenu: Codable {
    let id: String
    let heading: String
    let url: String
    let sms: String
    let mds: String
    let lgs: String
    let exs: String
    let xls: String
  //  let submenu: String
    let itemList: [RestItemList]?
}
struct RestItemList: Codable {
    let completeMeal: String
    let id: String
    let heading: String
    let details: String?
    let sm: Float
    let md: Float
    let lg: Float
    let ex: Float
    let xl: Float
    let minqty: Int
    var getMinimumPrice: [Float] {
        var arr = [Float]()
        if sm > 0 {
            arr.append(sm)
        }
        if md > 0 {
            arr.append(md)
        }
        if lg > 0 {
            arr.append(lg)
        }
        if ex > 0 {
            arr.append(ex)
        }
        if xl > 0 {
            arr.append(xl)
        }
      //  print(arr.sorted())
      //  print(arr.sorted().last)
        return arr.sorted()
    }
}
struct RestOffer: Codable {
    let id: String
    let code: String
    let types: String
    let amount: Float
    let minorder: Float
}
struct DineTime: Codable {
    let hour: Int
    let value: String
}
