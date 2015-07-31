//
//  Response.swift
//  ServerAccessSDK
//
//  Created by Tomohiro Teranishi on 7/31/15.
//  Copyright (c) 2015 Tomohiro Teranishi. All rights reserved.
//


import Foundation
import SwiftyJSON


public enum APIError : Int {
    case NONE  = 0
    case ERROR = 1
    case CLIENT_UPGRADE_VERSION = 2
    case CLIENT_UPGRADE_MASTER = 3
    case CLIENT_MAINTENANCE = 4
}

public class ResponseBase {
    var json : JSON = []
    
    public func load(json:JSON) ->Void {
        fatalError("abstract method")
    }
}

public class ResponseAPIError : ResponseBase {
    
    var apiError : APIError = APIError.ERROR
    
    public init(json:JSON){
        super.init()
        
        self.load(json)
    }
    
    public override func load(json:JSON) ->Void {
        self.json = json
        println(json)
        self.apiError = APIError(rawValue :json["error"].intValue)!
        
    }
    
    
}