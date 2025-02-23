//
//  AppModule.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/23.
//

import Foundation
import Alamofire
import Moya

private let appModule = AppModule()

class AppModule: NSObject {
    
    var token = ""
    
    let whiteList = ["/v1/forecast"]
    
    let hudPlugin = NetworkActivityPlugin { state, target in
        if state == .began {
            HUDManager.shared.show()
            print("开始请求网络数据...")
        } else {
            HUDManager.shared.hide()
            print("请求网络数据结束...")
        }
    }
    
    class var sharedInstance: AppModule {
        return appModule
    }
    
}

extension AppModule {
    
    func session() -> Alamofire.Session {
        return Alamofire.Session(configuration: {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 10
            configuration.timeoutIntervalForResource = 20
            return configuration
        }())
    }
    
    func sessionHeader(_ path: String) -> [String: String] {
        if whiteList.contains(path) {
            return [:]
        } else {
            return [
                "Authorization" : "Bearer \(token)"
            ]
        }
    }
    
}
