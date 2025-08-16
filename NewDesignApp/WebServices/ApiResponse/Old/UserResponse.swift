//
//  UserResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 08/11/24.
//

import Foundation
struct UserResponse: Codable {
    var customer: User
}
struct User: Codable {
    var address: [UserAdd]?
    let coupons: Coupons?
    let customer_id: String
    let email: String
    let fname: String
    let lname: String
    let phone: String
    let orders: Int?
}
struct Coupons: Codable {
    let amount: String
    let code: String
    let min: String
    let text1: String
    let text2: String
    let text3: String
    let text4: String
    let text5: String
    let type: String
}
struct UserAdd: Codable {
    let add1: String
    let add2: String
    let city: String
    let id: String
    let state: String
    let street: String
    let type: String
    let zip: String
}
struct RemoveAddressResponse: Codable {
    var message: String
    var result: String
}
struct AddedAddressResponse: Codable {
    var add_id: String
    var message: String
}
struct FavoriteResponse: Codable {
    var message: String
    var result: String
}
struct ChangePasswordResponse: Codable {
    var message: String
    var result: String
}
struct DineBookedResponse: Codable {
    var result: String
    var status: String
    var support: String
    var id: String
}
struct GetAddressResponse: Codable {
    var result: String
    var message: String
    var address: [UserAdd]
}
