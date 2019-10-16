//
//  SendNotification.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation

func sendPushNotification(to token: String, title: String, body: String) {
    
    var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=AIzaSyDgJ0C-MQui4Fz6claYyrg2ArhYgwjt33k", forHTTPHeaderField: "Authorization")
    
    let json = [
        "to" : token,
        "priority" : "high",
        "notification" : [
            "body" : body,
            "Title": title
        ]
        ] as [String : Any]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("Status Code should be 200, but is \(httpStatus.statusCode)")
                print("Response = \(String(describing: response))")
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    catch {
        print(error)
    }
}
