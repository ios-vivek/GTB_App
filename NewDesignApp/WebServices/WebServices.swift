//
//  WebServices.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 23/08/24.
//

import UIKit
import Alamofire
import CoreLocation

enum HomeListAPIResponse {
    case Success(HomeListDataResponse)
    case Fail(APIError) /// Error code, Error message
}

struct APIError: Codable {
    let code: Int
    let message: String
}




struct APIResponse<T: Decodable>: Decodable {
   // var errors: APIError
    var data: T
}


class WebServices: NSObject {
    public static func getAppIDAndKeyWithCustomerID() -> [String: AnyObject] {
       // "customer_id" : "19012412412921" as AnyObject

        let parameters: [String: AnyObject] = [
            "api_id" : AppConfig.API_ID as AnyObject,
            "api_key" : AppConfig.OldAPI_KEY as AnyObject,
            "customer_id" : APPDELEGATE.userResponse?.customer.customer_id as AnyObject,
            "device_version" : "kDeviceVersion" as AnyObject,
            "device_type" : AppConfig.DeviceType as AnyObject,
            "device_token" : "APPDELEGATE.getDeviceToken" as AnyObject

        ]
        return parameters
    }
    public static func loadDataFromService<T:Codable>(parameter: [String: AnyObject], servicename: String, forModelType modelType: T.Type, SuccessHandler: @escaping (APIResponse<T>) -> Void, ErrorHandler: @escaping (String) -> Void) {
        var errorMsg = ""
        let requestUrl = OldServiceType.BASE + servicename
        print("Request url: \(requestUrl) \n Request Data: \(parameter.json)")
        AF.request(requestUrl,
                   method: .post,
                   parameters: parameter,
                   encoding: URLEncoding.default,
                   interceptor: nil)
            .response(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                                       let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                        print("Response Data: \(jsonResponse)")
                                  // let string = String(bytes: data!, encoding: .utf8)
                                  //  print("Response Data in string : \(string)")
                        if servicename == "request/Profile" || servicename == "request/ChangePassword" || servicename == "user/" || servicename == "register/" || servicename == "request/ForgetPassword"{
                          //  guard let resultNew = jsonResponse as? [String:Any]

                           // let email = resultNew["email"]  as! String
                            if let result = jsonResponse as? [String:Any] {
                                errorMsg  = result["result"] as? String ?? ""
                            }
                        }
                        let listData = try JSONDecoder().decode(modelType.self, from: JSONSerialization.data(withJSONObject: jsonResponse))
                       // print(listData)
                                      // print(jsonResponse as! NSDictionary)
                        SuccessHandler(APIResponse(data: listData))
                                   }
                                   catch let error
                                   {
                                       print(error)
                                       ErrorHandler(errorMsg)
                                   }
                    
                case .failure(let error):
                               /// Handle request failure
                    ErrorHandler(error.localizedDescription)
                           }
            })
    }
    public static func loadDataFromService1<T:Codable>(parameter: [String: Any], servicename: String, forModelType modelType: T.Type, SuccessHandler: @escaping (APIResponse<T>) -> Void, ErrorHandler: @escaping (String) -> Void) {
        var errorMsg = ""
        let requestUrl = OldServiceType.BASE + servicename
        print("Request url: \(requestUrl) \n Request Data: \(parameter.json)")
        AF.request(requestUrl,
                   method: .post,
                   parameters: parameter,
                   encoding: URLEncoding.default,
                   interceptor: nil)
            .response(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                                       let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                        print("Response Data: \(jsonResponse)")
                                  // let string = String(bytes: data!, encoding: .utf8)
                                  //  print("Response Data in string : \(string)")
                        if servicename == "request/Profile" || servicename == "request/ChangePassword" || servicename == "user/" || servicename == "register/" || servicename == "request/ForgetPassword"{
                          //  guard let resultNew = jsonResponse as? [String:Any]

                           // let email = resultNew["email"]  as! String
                            if let result = jsonResponse as? [String:Any] {
                                errorMsg  = result["result"] as? String ?? ""
                            }
                        }
                        let listData = try JSONDecoder().decode(modelType.self, from: JSONSerialization.data(withJSONObject: jsonResponse))
                       // print(listData)
                                      // print(jsonResponse as! NSDictionary)
                        SuccessHandler(APIResponse(data: listData))
                                   }
                                   catch let error
                                   {
                                       print(error)
                                       ErrorHandler(errorMsg)
                                   }
                    
                case .failure(let error):
                               /// Handle request failure
                    ErrorHandler(error.localizedDescription)
                           }
            })
    }

    public static func placeOrderService(parameters: [String: AnyObject], successHandler: @escaping (_ successResult: [String:Any]) -> Void, errorHandler: @escaping (_ errorResult: String) -> Void) {
      //  Loader.showLoader()
        
        let requestUrl = OldServiceType.BASE + "add-order/"
        AF.request(requestUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
        response in

           // Loader.hideLoader()
            switch(response.result) {
            case .success(let value):
            if let json = value as? [String: Any] {
                print(json)
                
                        if let customerData = json["status"] as? String{
                            if ((customerData.elementsEqual("success")) == true)
                            {
                                successHandler(json)
                            }
                            else
                            {
                                Cart.shared.orderNumber = json["id"] as? String ?? ""
                                print("\(Cart.shared.orderNumber)")
                                 if let errordata = json["error"] as? String{
                                    errorHandler(errordata)
                                 }
                                else if let resultdata = json["result"] as? String{
                                    errorHandler(resultdata)
                                 }else{
                                   errorHandler("Failed")
                                }
                            }
                            
                        }else{
                            errorHandler("Something error")
                        }
                
                        
                    }else{
                        errorHandler("Something error")
                    }
                
                break
                
            case .failure(let error):

                print(error)
            errorHandler(error.errorDescription!)
                               }
        }
    }

    public static func googleAddressSearch<T:Codable>(searchtext: String, forModelType modelType: T.Type, SuccessHandler: @escaping (APIResponse<T>) -> Void, ErrorHandler: @escaping (String) -> Void) {
        if APPDELEGATE.selectedLocationAddress.latLong == nil {
            APPDELEGATE.selectedLocationAddress = LocationAddress()
            let latLong : CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
            APPDELEGATE.selectedLocationAddress.latLong = latLong
        }
        let requestUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchtext)&components=country:AE&types=establishment&location=\(APPDELEGATE.selectedLocationAddress.latLong.latitude)%2C\(APPDELEGATE.selectedLocationAddress.latLong.longitude)&radius=500&key=\(GoogleApiKey)"
        AF.request(requestUrl,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   interceptor: nil)
            .response(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                                       let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(jsonResponse)

                        let listData = try JSONDecoder().decode(modelType.self, from: JSONSerialization.data(withJSONObject: jsonResponse))
                        print(listData)
                                       print(jsonResponse as! NSDictionary)
                        SuccessHandler(APIResponse(data: listData))
                                   }
                                   catch let error
                                   {
                                       print(error)
                                       ErrorHandler("")
                                   }
                    
                case .failure(let error):
                               /// Handle request failure
                    ErrorHandler(error.localizedDescription)
                           }
            })
    }
    public static func googleAddressLatLong<T:Codable>(searchtext: String, forModelType modelType: T.Type, SuccessHandler: @escaping (APIResponse<T>) -> Void, ErrorHandler: @escaping (String) -> Void) {
        let requestUrl = "https://maps.googleapis.com/maps/api/geocode/json?address=\(searchtext)&key=\(GoogleApiKey)"
               
        AF.request(requestUrl,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   interceptor: nil)
            .response(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                                       let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(jsonResponse)

                        let listData = try JSONDecoder().decode(modelType.self, from: JSONSerialization.data(withJSONObject: jsonResponse))
                        print(listData)
                                       print(jsonResponse as! NSDictionary)
                        SuccessHandler(APIResponse(data: listData))
                                   }
                                   catch let error
                                   {
                                       print(error)
                                       ErrorHandler("")
                                   }
                    
                case .failure(let error):
                               /// Handle request failure
                    ErrorHandler(error.localizedDescription)
                           }
            })
    }
    
    public static func googleAddressFromLatLong<T:Codable>(searchtext: String, forModelType modelType: T.Type, SuccessHandler: @escaping (APIResponse<T>) -> Void, ErrorHandler: @escaping (String) -> Void) {
               let requestUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(searchtext)&key=\(GoogleApiKey)"
               
        AF.request(requestUrl,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   interceptor: nil)
            .response(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                                       let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(jsonResponse)

                        let listData = try JSONDecoder().decode(modelType.self, from: JSONSerialization.data(withJSONObject: jsonResponse))
                        print(listData)
                                       print(jsonResponse as! NSDictionary)
                        SuccessHandler(APIResponse(data: listData))
                                   }
                                   catch let error
                                   {
                                       print(error)
                                       ErrorHandler("")
                                   }
                    
                case .failure(let error):
                               /// Handle request failure
                    ErrorHandler(error.localizedDescription)
                           }
            })
    }

}
