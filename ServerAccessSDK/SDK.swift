//
//  SDK.swift
//  ServerAccessSDK
//
//  Created by Tomohiro Teranishi on 7/31/15.
//  Copyright (c) 2015 Tomohiro Teranishi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class Command {
    
    public var path : String = ""
    var method : String = ""
    
    
    public init(path:String){
        self.path = path
        self.method = Alamofire.Method.POST.rawValue
    }
    
    public init(path:String,method:String){
        self.path = path
        self.method = method
    }

    
}


public class ClientBase {
    
    
    
    public let accessTokenKey : String = "X-ACCESS-TOKEN"
    
    public init(){}
    

    public func getAccessToken() -> String {
        preconditionFailure("This method must be overridden")
    }
    
    public func getEndpoint() -> String {
        preconditionFailure("This method must be overridden")
        
    }
    
    public func responseMaker(cmd:Command,json:JSON) -> ResponseBase {
        preconditionFailure("This method must be overridden")
    }
    
    // overwrite this method when u want to use basic auth
    public func getBasicAuthInfo()-> NSURLCredential? {
        // let credential = NSURLCredential(user: user, password: password, persistence: persistence)
        return nil
    }
    
    static func onDefaultError( e : ResponseAPIError ){
        print(e)
    }
    static func onCriticalError( e : NSError ){
        print(e)
    }
    
    
    
    public func get(
        command : Command,
        parameters: [String: AnyObject]? = nil,
        onSuccess : ( ResponseBase ) -> Void,
        onError : ( ResponseAPIError ) -> Void = {
            ( e : ResponseAPIError ) in
            ClientBase.onDefaultError(e)
        },
        onCriticalError : ( NSError ) -> Void = {
            ( e : NSError) in
            ClientBase.onCriticalError(e)
        },
        onFinalize : () -> Void
        
        )  {
            
            let url  = self.getEndpoint() + command.path
            let mutableURLRequest = NSMutableURLRequest(URL : NSURL(string: url)!)
            
            mutableURLRequest.HTTPMethod = command.method
    
            if self.getAccessToken() != "" {
                
                mutableURLRequest.setValue(self.getAccessToken(), forHTTPHeaderField: self.accessTokenKey)
            }
            
            let (m, _) = ParameterEncoding.URL.encode(mutableURLRequest,parameters:parameters)

            
            var requestObject = Alamofire.request(m)
            let basicAuthInfo =  self.getBasicAuthInfo()
            if basicAuthInfo != nil {
                requestObject = requestObject.authenticate( usingCredential: basicAuthInfo! )
            }
            
            requestObject.responseSwiftyJSON({ (request, response, json, error) in
                if(error == nil ){
                    let apiError = APIError(rawValue :json["error"].intValue)
                    
                    if apiError == APIError.NONE {
                        let res: ResponseBase = self.responseMaker(command,json:json)
                        onSuccess(res)
                    }
                    else {
                        let res = ResponseAPIError(json: json)
                        onError(res)
                    }
                }else{
                    onCriticalError(error!)
                }
                
                onFinalize()
                
            })

            
    }
    
}
