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
    
    var path : String = ""
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
    
    
    
    public var endpoint: String = ""
    public let accessTokenKey : String = "X-ACCESS-TOKEN"
    
    public init(){
        //self.setupEndpoint()
    }
    
    
    public func setupEndpoint(){
        preconditionFailure("This method must be overridden")
        
    }
    
    public func responseMaker(cmd:Command,json:JSON) -> ResponseBase {
        preconditionFailure("This method must be overridden")
    }
    
    public func getAccessToken() -> String {
        preconditionFailure("This method must be overridden")
    }
    
    static func onDefaultError( e : ResponseAPIError ){
        println(e)
    }
    static func onCriticalError( e : NSError ){
        println(e)
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
            
            let url  = self.endpoint + command.path
            let mutableURLRequest = NSMutableURLRequest(URL : NSURL(string: url)!)
            
            mutableURLRequest.HTTPMethod = command.method
    
            if self.getAccessToken() != "" {
                
                mutableURLRequest.setValue(self.getAccessToken(), forHTTPHeaderField: self.accessTokenKey)
            }
            
            let (m,error) = ParameterEncoding.URL.encode(mutableURLRequest,parameters:parameters)

            
            Alamofire.request(m).responseSwiftyJSON({ (request, response, json, error) in
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
