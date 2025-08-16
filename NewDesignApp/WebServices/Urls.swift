//
//  Urls.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 23/08/24.
//

import Foundation
let GoogleApiKey = "AIzaSyAcpD8juDqASzLRWCdNP-ns4UzdVph1koU"

struct AppConfig {
    static let OldAPI_KEY = "ba6ee13256e5f0d75eacbf87de167541"
    static let API_ID = "GB19AP01"
   // static let API_KEY = "ba6ee13256e5f0d75"
    static let DeviceType = "iOS"
    static let DeviceToken = "123456"
}
// https://www.webapi.grabthebites.com/
// https://www.webapi.grabthebites.com/ios/
// https://www.webapi.grabthebites.com/android/
struct OldServiceType {
    //static let BASE = "https://www.webapi.grabthebites.com/ios/"
    static let BASE = "https://www.grabull.com/web-api-ios/"

    static let resturantList = "restaurant/GetAllRestaurant"
    static let cuisine = "cuisine/"
    static let restaurantDetail = "restaurant-details/GetRestaurantById"
    //static let restaurantDetail = "restaurant-details-new/GetRestaurantById"
    static let getFavorite = "request/Favorite"
    static let addFavorite = "request/addFavoritres"
    static let removeFavorite = "request/RemoveFavorite"
    static let getReward = "reward/"
    static let getAddress = "request/GetAddress"
    
    
    static let getLogin = "user/"
    static let getSignup = "register/"
    static let editProfile = "request/Profile"
    static let forgotpass = "request/ForgetPassword"
    static let changePassword = "request/ChangePassword"
    static let removeAddress = "request/RemoveAddress"
    static let addAddress = "request/AddAddress"
    static let updateAddress = "request/UpdateAddress"
    static let options = "options/GetAllOptionsByItem"
    static let restaurantTime = "restaurant-time/GetRestaurantTimingById"
    static let orderHistory = "request/OrderHistory"
    static let bookdine = "book-dine/"
    static let placeOrder = "add-order/"
    static let getDineInOrders = "dine-history/"
    static let addReview = "add-reviews/"
    static let getReview = "view-reviews/"
    static let updateReview = "update-reviews/"


    
    static let hiddenRestList = "hiddenRestList"
    static let favoriteRest = "favoriteRestList"
    static let hiddenRest = "hiddenRest"



    static let imageUrl = "https://www.grabull.com/restaurants-search/pics/"
    static let cuisineImageUrl = "https://www.grabull.com/files/cuisine-icons/"
    static let restaurantImageUrl = "https://www.grabull.com/files/restaurant/"
}
