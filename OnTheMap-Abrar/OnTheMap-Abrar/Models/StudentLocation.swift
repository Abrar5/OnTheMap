//
//  StudentLocation.swift
//  OnTheMap-Abrar
//
//  Created by Abrar on 1/3/19.
//  Copyright © 2019 Abrar. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?

  
        init(_ dictionary: [String: AnyObject]) {
            self.createdAt = dictionary["createdAt"] as? String ?? " "
            self.firstName = dictionary["firstName"] as? String ?? " "
            self.lastName = dictionary["lastName"] as? String ?? " "
            self.latitude = dictionary["latitude"] as? Double ?? 0.0
            self.longitude = dictionary["longitude"] as? Double ?? 0.0
            self.mapString = dictionary["mapString"] as? String ?? " "
            self.mediaURL = dictionary["mediaURL"] as? String ?? " "
            self.objectId = dictionary["objectId"] as? String ?? " "
            self.uniqueKey = dictionary["uniqueKey"] as? String ?? " "
            self.updatedAt = dictionary["updatedAt"] as? String ?? " "
        }

    
   
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }

}

enum Parameter: String {
    case createdAt
    case firstName
    case lastName
    case latitude
    case longitude
    case mapString
    case mediaURL
    case objectId
    case uniqueKey
    case updatedAt
}

