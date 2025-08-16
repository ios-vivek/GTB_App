//
//  HistoryResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 28/11/24.
//

import Foundation
struct HisoryResponse: Codable {
    let result: String?
    let status: String?
    var data: [HistoryOrder]
}
struct HistoryOrder: Codable {
    let order: String
    let resturant_id: String
    let resturant: String
    let img: String
    let rating: String?
    let date: String
    let date2: String
    let zone: String
    let type: String
    let pickup_address: String
    let delivery: String
    let streets: String
    let address: String
    let landmark: String
    let city: String
    let state: String
    let zip: String
    let country: String
    let orderat: String
    let HoldOrder: String
    let ordertime: String
    let status: String
    let name: String
    let mobile: String
    let email: String
    let subtotal: Float
    let tip: Float
    let tip2: Float
    let tax: Float
    let deliverycharge: Float
    let offer: [Offer]?
    let discount: Float
    let reward: Float
    let total: Float
    let details: String
    let orderItems: [OrderItems]
    let addedItems: [String]
    let trackorder: String
    
}
struct OrderItems: Codable {
    let item: String
    let instruction: String
    let qty: String
    let price: String
    let extra: String
    let examount: String
}
