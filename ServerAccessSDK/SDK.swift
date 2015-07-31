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
    
    var name : String = ""
    var path : String = ""
    
    public init(name : String,path :  String){
        self.name = name
        self.path = path
    }
    
}


public class ClientBase {
    
    let endpoint : String = ""
    
    public init(){
        self.setupEndpoint()
    }
    
    
    func setupEndpoint(){
        preconditionFailure("This method must be overridden")
        
    }
    
    func responseMaker(cmd:Command,json:JSON) -> ResponseBase {
        preconditionFailure("This method must be overridden")
    }
    
    func getAccessToken(){
        preconditionFailure("This method must be overridden")
    }
    
    static func onDefaultError( e : ResponseAPIError ){
        println(e)
    }
    static func onCriticalError( e : NSError ){
        println(e)
    }
    
    
    
    public func get(
        cmd : Command,
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
            
            
            let url  = self.endpoint + cmd.path
            let mutableURLRequest = NSMutableURLRequest(URL : NSURL(string: url)!)
            
            
            Alamofire.request(mutableURLRequest).responseSwiftyJSON({ (request, response, json, error) in
                if(error == nil ){
                    let apiError = APIError(rawValue :json["error"].intValue)
                    
                    if apiError == APIError.NONE {
                        let res: ResponseBase = self.responseMaker(cmd,json:json)
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
