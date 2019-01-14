//
//  API.swift
//  OnTheMap-Abrar
//
//  Created by Abrar on 1/3/19.
//  Copyright © 2019 Abrar. All rights reserved.
//

import Foundation
import UIKit

class API {
    
    private static var userInfo = UserInfo()
    private static var sessionId: String?
    

    static func postSession_login(username: String, password: String, completion: @escaping (String?)->Void) {
        guard let url = URL(string: Constants.Session) else {
            completion("URL is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(Constants.HTTPHeaderFieldValue.json, forHTTPHeaderField: Constants.HTTPHeaderField.accept)
        request.addValue(Constants.HTTPHeaderFieldValue.json, forHTTPHeaderField: Constants.HTTPHeaderField.contentType)
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errorString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dictionary = json as? [String:Any],
                        let sessionDict = dictionary["session"] as? [String: Any],
                        let accountDict = dictionary["account"] as? [String: Any]  {
                        
                        self.userInfo.uniqueKey = accountDict["key"] as? String
                        self.sessionId = sessionDict["id"] as? String
                        
                        self.getStudentInfo(completion: { err in

                        })
                    } else {
                        errorString = "Couldn't parse response"
                    }
                } else {
                    errorString = "Wrong Email or/and Password"
                }
            } else {
                errorString = "NO internet connection"
            }
            DispatchQueue.main.async {
                completion(errorString)
            }
            
        }
        task.resume()
    }
    
    
    static func deleteSession_logout(handler: @escaping (_ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: Constants.Session)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) 
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
 
    static func getStudentInfo(completion: @escaping (Error?)->Void) {
       
        guard let userId = self.userInfo.uniqueKey, let url = URL(string: "\(Constants.Public_Users)\(userId)") else {
           completion(NSError(domain: "URLError", code: 0, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(self.sessionId!, forHTTPHeaderField: "session_id")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            //var firstName: String?, lastName: String?, name: String = ""
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 400 {
                    let newData = data?.subdata(in: 5..<data!.count)
                
                if let json = try? JSONSerialization.jsonObject(with: newData!, options: [.allowFragments]),
                let dictionary = json as? [String:Any] {
                  let name = dictionary["name"] as? String ?? " "
                  let firstName = dictionary["first_name"] as? String ?? name
                  let lastName = dictionary["last_name"] as? String ?? name
                
                 userInfo.firstName = firstName
                 userInfo.lastName = lastName
                    
                  print("" +  userInfo.firstName! + " " +  userInfo.lastName!)
                  print("" + firstName + " " + lastName)

                }
            }
        
            DispatchQueue.main.async {
                completion(nil)
            }
            
        }
        task.resume()
        }
    

    class Parser {
        
        static func getStudentsLocations(limit: Int = 100, skip: Int = 0, orderBy: Parameter = .updatedAt, completion: @escaping (LocationsData?)->Void) {
            guard let url = URL(string: "\(Constants.Student_Location)?\(Constants.ParameterKeys.Limit)=\(limit)&\(Constants.ParameterKeys.Skip)=\(skip)&\(Constants.ParameterKeys.Order)=-\(orderBy.rawValue)") else {
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(Constants.ParseParameterValues.ApplicationID, forHTTPHeaderField: Constants.ParseParameterKeys.ApplicationID)
            request.addValue(Constants.ParseParameterValues.ApiKey, forHTTPHeaderField: Constants.ParseParameterKeys.ApiKey)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    return
                }
                var studentLocations: [StudentLocation] = []
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode >= 200 && statusCode < 300 {
                        
                        if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                            let dictionary = json as? [String:Any],
                            let results = dictionary["results"] as? [Any] {
                            
                            for location in results {
                                let data = try! JSONSerialization.data(withJSONObject: location)
                                let studentLocation = try! JSONDecoder().decode(StudentLocation.self, from: data)
                                studentLocations.append(studentLocation)
                            }
                            
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(LocationsData(studentLocations: studentLocations))
                }
                
            }
            task.resume()
            
        }
        
        static func postStudentLocation(_ location: StudentLocation, completion: @escaping (String?)->Void) {
        
            var request = URLRequest(url: URL(string: Constants.Student_Location)!)
            request.httpMethod = "POST"
            request.addValue(Constants.ParseParameterValues.ApplicationID, forHTTPHeaderField: Constants.ParseParameterKeys.ApplicationID)
            request.addValue(Constants.ParseParameterValues.ApiKey, forHTTPHeaderField: Constants.ParseParameterKeys.ApiKey)
            request.addValue(Constants.HTTPHeaderFieldValue.json, forHTTPHeaderField: Constants.HTTPHeaderField.contentType)
            request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(location.firstName ?? "Efrain")\", \"lastName\": \"\(location.lastName ?? "Barton")\",\"mapString\": \"\(location.mapString ?? "Dammam, Saudi Arabia")\",\"mediaURL\": \"\(location.mediaURL ?? "https://www.google.com")\",\"latitude\": \(location.latitude ?? 26.399250), \"longitude\": \(location.longitude ?? 49.984360)}".data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    return
                }
            print(String(data: data!, encoding: .utf8)!)

            }
            
            task.resume()
            
        }
    }
  
}



