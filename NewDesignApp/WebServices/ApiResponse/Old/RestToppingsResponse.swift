//
//  RestToppingsResponse.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/11/24.
//

import Foundation

struct RestToppingsResponse: Codable {
    let id: String
    let heading: String
    let choice: String
    let free: String
    let charge: String
    let required: String
    let optionlist: [RestOptionList]?
    var restChoice: Int {
      return Int(choice) ?? 0
    }
}
struct RestOptionList: Codable {
    let id: String
    let heading: String
    let selected: String
    let sm: String
    let md: String
    let lg: String
    let ex: String
    let xl: String
}
