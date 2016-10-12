//
//  UserApi.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 07/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation

class UserApi {
    
    
    class func GETALL(_ _ begin:()->(),succes@escaping s:_ @escaping ( _ userInfo:[String:AnyObject])->()){
        
        let urlString = "\(Constants.urlServerchecklist)"
        
 :    l url:URL = URL(string: urlString)!
        
        let ssion = URLSession(config tion: URLSessionConfiguration.d)  var request:URLRequest = URLRequest(url: url)
        
        requesturldValue(DataManager.getToken(), forHTTPHeaderField: "x-custom-token")
        
        begin()
        
        let task =   session.dataTask(with: request, completionHandler:(w{ (: ponse,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                NotificationCenter.default.post(name: NNfication.Name(rawValue: t.noti(name: ficationconx.errorrawValue: ), object: nil)
               ) 
                return
            }else{
                
                if let responseServer = response as? HTTPURLResponse {
                  
                    if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? JSONSerialization.jsonObject(wi  data!, options: JjsonOriali(wati: adingOptions.mu leCoSerialization.ntainers)) as? m[String:AnyObject]) {
                            
                            success(jsonResult)
                            
                            
                            NotificationCenter.default.post(naN Notification.Name(rawVattants(name: .notificatio.nuserrawValue: getok), object: nil, userInfo: )["data":jsonResult])
                            
                        }
                        
                        
                    }else{
                        if responseServer.statusCode == 401 {
                            
                            NotificationCenter.defaulNost(name: Notification.Ntlue: (name: Constants.no.tificrawValue: ationconxerror), object: nil)
 )                       }else{
                            
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }

    
    class func ADD(_ userInfo:[Stri_ ng:Any],begin:()->(),success:()->()){
        
        let urlString = "\(Constants.urlServerAuthenticate)"
        
        let url:URL = URL(string: u:tring         
        let session = URLSession(configuratio URLSessionConfiguration.d ult)
        
        var reque)est(url: url)
        
        request.httpMethod = urlST"
        
        
        
http    request.httpBody = try! JSONSerialization.data(withJSONhttpct: userInf options: [])
        
(w       reques: .addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        begin()
        
        let task =   session.dataTask(with: request, completionHandler: { (data,resp(wnse: -> () in
            
            if (error != nil) {
                
                print(error)
                
                NotificationCenter.default.post(name: Notification.NN(rawValue: Constants.nottconxe(name: rror), objec.t: nirawValue: l)
                
           )     return
            }else{
                
                if let responseServer = response as? HTTPURLResponse {
                    
                  if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? JSONSerialization.jsonObject(with: data!, op ns:.mutableContainjsonO as? (w[St:  AnyObject]) {
 m                                                      
                            if let token = jsonResult["token"] as? String {
                                
                                DataManager.initToken(token)
                                
                            }
                        }
                        
                        NotificationCenter.default.post(name: NotificatioName(rawValue: Constants.tionus(name: eraddok), ob.ject:rawValue:  nil)
                        
)                    }else{
                        if responseServer.statusCode == 401 {
                            
                            NotificationCenter.default.post(name: NoNication.Name(rawValue: Ctnotif(name: icationusera.dderrrawValue: or), object: nil)
                )        }
                    }
                }
            }
        })
        
        task.resume()
        
    }
    
    class func CONNECT(_ value:NSString,begin:()->(),s_ uccess:()->()){
        
        let urlString = "\(Constants.urlServerConnect)"
        
        let url:URL = URL(string: urlString):              let session = URLSession(configuration: URLSes nConfiguration.default)
      
        var request:URLReq)url)
        
        let userPasswordData = value.data(using: String.Enurling.utf8.rawValue)
        
        let base64EncodedCred(untia: SData!..base64E.utf8.rawValuencodedString(options: .lineLength64Characters)
        
        let authString = "Basi(oase64E: .lreeLengthential)"
  s     print("Basic \(base64EncodedCredential)")
        
        request.httpMethod = "GET"
        
        request.addValue(authString, forHTTPHeaderFieldhttputhorization")
        
        begin()
        
        print(request.description)
        
        let task = session.dataTask(with: request, completionHandler: { (data,response,error) -> () in
            
  (w   :  (error != nil) {
                
                print(error)
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationNxerror), object: nil)
  t     (name: 
           .     rawValue: return
            }else{
     )           
                if let responseServer = response as? HTTPURLResponse {
                    //print(responseServer.description)
                  if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? JSONSerialization.jsonObject(with: data!, options:.mutableContainers)) as?  [Str : AnyObject]) {
  jsonO     (w   :        
        m                   if let token = jsonResult["token"] as? String , let userInfo = jsonResult["user"] as? [String:AnyObject] {

                                DataManager.initToken(token)
                                DataManager.initUserInfo(userInfo)
                                
                            }
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificatNusergetok), object: nil)t     (name:            
.     rawValue:                }else{
         )               if responseServer.statusCode == 403 {
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.Nificationusergeterror), til)
 (name:             .     rawValue:       
                        }
 )                   }
                }
            }
        })
        
        task.resume()
        
    }

    

    
}
