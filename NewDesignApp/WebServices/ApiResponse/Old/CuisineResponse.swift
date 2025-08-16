//
//  CuisineResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 07/11/24.
//

import Foundation
struct SavedLocation: Codable {
    let locations: [Localocation]
}
struct Localocation: Codable {
    let addressID : String!
    let subLocality : String!
    let zipcode : String!
    let city : String!
    let state : String!
    let country : String!
    let lat : String!
    let long : String!
    let locality : String!
    let premise : String!
    let streetNumber : String!
    let route : String!
}
struct CuisineResponse: Codable {
    let cuisine: [Cuisine]
    let banner: String
    let cuisine_heading: String
    let slider: [RestSlider]
    let coupon: [Coupon]
}
struct Cuisine: Codable {
    let heading: String
    let url: String
    let img: String
    var cuisineImage: String {
        return OldServiceType.cuisineImageUrl + img
    }
}
struct RestSlider: Codable {
    let url: String
}
struct Coupon: Codable {
    let amount: String
    let code: String
    let heading: String
    let min: String
    let text1: String
    let text2: String
    let text3: String
    let text4: String
    let text5: String
    let type: String
}
struct PastOrderRest: Codable {
    let restId: String
    let count: Int
}

struct SavedAddressInDB: Codable {
    let address: String
    let date: Date
}
