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
    case CLIENT_UPGRADE_DATA = 3
    case CLIENT_MAINTENANCE = 4
}

public class ResponseBase {
    public var json : JSON = []
    
    public init(){}
    
    public func load(json:JSON) ->Void {
        fatalError("abstract method")
    }
}

public class ResponseAPIError : ResponseBase {
    
    public var apiError : APIError = APIError.ERROR
    public var code  : String = ""
    
    public init(json:JSON){
        super.init()
        
        self.load(json)
    }
    
    public override func load(json:JSON) ->Void {
        self.json = json
        self.apiError = APIError(rawValue :json["error"].intValue)!
        self.code = json["error_code"].stringValue
        
    }
    
    
}
