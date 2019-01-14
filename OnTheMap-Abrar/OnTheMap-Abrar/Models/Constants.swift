//
//  Constants.swift
//  OnTheMap
//
//  Created by Abrar on ٢٥‏/١٢‏/٢٠١٨.
//  Copyright © ٢٠١٨ Abrar. All rights reserved.
//

import Foundation

struct Constants {

    private static let MainURL = "https://parse.udacity.com"
    static let Session = "https://onthemap-api.udacity.com/v1/session"
    static let Public_Users = "https://onthemap-api.udacity.com/v1/users/"
    static let Student_Location = MainURL + "/parse/classes/StudentLocation"
    
    struct ParseParameterKeys {
        static let ApiKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
    }
    
    struct ParseParameterValues {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
    }
    
    struct HTTPHeaderField {
        static let accept = "Accept"
        static let contentType = "Content-Type"
    }
    
    struct HTTPHeaderFieldValue {
        static let json = "application/json"
    }
    
    struct ParseJSONResponseKeys {
        static let Results = "results"
    }
    
}

