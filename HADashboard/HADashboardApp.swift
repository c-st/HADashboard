//
//  HADashboardApp.swift
//  HADashboard
//
//  Created by Edward Byne on 26.01.21.
//

import SwiftUI
import HAClient

#if canImport(UIKit)
import UIKit
class AppDelegateAdaptor: NSObject, UIApplicationDelegate {
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("applicationDidFinishLaunching")
    }
}
#elseif canImport(AppKit)
import AppKit
class AppDelegateAdaptor: NSObject, NSApplicationDelegate, ObservableObject {

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("applicationDidFinishLaunching")
        let client = HAClient(messageExchange: WebSocketConnection(endpoint: "ws://homeassistant.raspberrypi.localdomain/api/websocket"))

        // Send auth token
        client.authenticate(
            token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIzNmFmZDMyMjdkYzQ0YmNlOGZiNDRhNTFiZDA4MDdkZSIsImlhdCI6MTYxMTI3MTQ2NiwiZXhwIjoxOTI2NjMxNDY2fQ.YDRag0Hvq0lrTvu4Rt_z9NAQAJJNManAP0g4wHBFRq0",
            onConnection: {
                client.requestRegistry()
                client.requestStates()
            },
            onFailure: { reason in
                print("Authentication failure", reason)
            }
        )
    }
}
#endif

struct Store {
    public let registry: Registry
    
    init() {
        let client = HAClient(messageExchange: WebSocketConnection(endpoint: "ws://homeassistant.raspberrypi.localdomain/api/websocket"))
        
        // Send auth token
        client.authenticate(
            token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIzNmFmZDMyMjdkYzQ0YmNlOGZiNDRhNTFiZDA4MDdkZSIsImlhdCI6MTYxMTI3MTQ2NiwiZXhwIjoxOTI2NjMxNDY2fQ.YDRag0Hvq0lrTvu4Rt_z9NAQAJJNManAP0g4wHBFRq0",
            onConnection: {
                client.requestRegistry()
                client.requestStates()
            },
            onFailure: { reason in
                print("Authentication failure", reason)
            }
        )
        self.registry = client.registry
    }
}

@main
struct HADashboardApp: App {
    
    @StateObject var store: Store = Store()
    
    #if canImport(UIKit)
    @UIApplicationDelegateAdaptor(AppDelegateAdaptor.self) private var appDelegate
    #elseif canImport(AppKit)
    @NSApplicationDelegateAdaptor(AppDelegateAdaptor.self) private var appDelegate
    #endif
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(store.registry)
        }
    }
}
