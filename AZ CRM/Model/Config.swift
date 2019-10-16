//
//  Config.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
import Alamofire

let taikhoan = UserDefaults.standard.string(forKey: "taikhoan")
let matkhau = UserDefaults.standard.string(forKey: "matkhau")

// xoá những biến lưu tạm
func removeUserDefaults() {
    UserDefaults.standard.removeObject(forKey: "taikhoan")
    UserDefaults.standard.removeObject(forKey: "matkhau")
}

func APIOnJson(paramer: Parameters!, completionHandler: @escaping(Dictionary<String, Any>?) -> ()) {
    do {
        if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
            print(urlRegister.last!.data!)
            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramer, encoding: JSONEncoding.default).responseJSON { (response) in
                
                switch response.result {
                case .success(let value):
                    let customerJson = value
                    completionHandler(customerJson as? Dictionary<String, Any>)
                case .failure(_):
                    completionHandler(nil)
                }
            }
        }
    } catch let error {
        print(error.localizedDescription)
    }
}
