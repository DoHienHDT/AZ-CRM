//
//  RequestCustomer.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
class RequestCustomer {
    
    static func getCustomer(parameter: Parameters!, completionHandler: @escaping (([Customer]) -> ())) {
        APIOnJson(paramer: parameter) { (customer) in
          
            var fetchedCustomer = [Customer]()
            if customer != nil {
                let arrayOfCustomer = customer!["data"] as! [[String: Any]]
                for customer in arrayOfCustomer {
                    
                    let valueMakh = customer["makh"] as? Int
                    let valueAbbreviationName = customer["tenviettat"] as? String
                    let valueCompany = customer["tencongty"] as? String
                    let valuePhone = customer["didong"] as? String
                    let valueMail = customer["email"] as? String
                    
                    let company: Customer = Customer(company: valueCompany ?? "", abbreviationName: valueAbbreviationName ?? "", mail: valueMail ?? "", phone: valuePhone ?? "", makh: valueMakh ?? 0)
                    fetchedCustomer.append(company)
                }
                
            } else {
                print("api customers nil")
                return
            }
            
            completionHandler(fetchedCustomer)
        }
    }
    
}



