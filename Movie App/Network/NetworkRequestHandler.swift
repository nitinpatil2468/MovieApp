//
//  NetworkRequestHandler.swift
//  Movie App
//
//  Created by Nitin Patil on 17/02/21.
//

import Foundation
import Alamofire

class NetworkRequestHandler{
    static let shared = NetworkRequestHandler()

    //Post method
    func POST(url:URL,parameters:Dictionary<String, Any>?,completion:@escaping(String?,Error?)->Void){
        
        let headers:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody , headers:headers).responseString(completionHandler: {
            response in
            switch response.result {
            
            case .failure(let error):
                print(error)
                completion(nil,error)
                
            case .success(let value):
                
                if let headerFields = response.response?.allHeaderFields as? [String: String],
                   let URL = response.request?.url
                {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                    var cookieDict = [String : AnyObject]()
                    for cookie in cookies {
                        
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                        
                    }
                    if cookies.count > 0 && cookieDict.count > 0  {
                        
                        if let cookies = HTTPCookieStorage.shared.cookies(for: URL) {
                            for cookie in cookies {
                                HTTPCookieStorage.shared.deleteCookie(cookie)
                            }
                        }
                        
                        self.setCookie(cookieDict: cookieDict)
                        HTTPCookieStorage.shared.setCookies(cookies, for: URL, mainDocumentURL:nil)
                    }
                    
                }
                
                
                completion(value,nil)
                
            }
            
        })
    }
    
    
    //get method
    func GET(url:URL,completion:@escaping([AnyHashable : Any]?,Error?)->Void){
        
        let headers:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        AF.request(url, method: .get, encoding: URLEncoding.httpBody,headers: headers)
            .responseJSON (completionHandler: {
                response in
                switch response.result {
                
                case .failure(let error):
                    print(error)
                    completion(nil,error)
                    
                case .success(let value):

                    completion(value as! [AnyHashable : Any],nil)
                }
            })
    }
    
    func setCookie (cookieDict:[String : AnyObject])
    {
        UserDefaults.standard.set(cookieDict, forKey: "cookies")
        UserDefaults.standard.synchronize()
    }
    
}
        
        

    

