import HAClient
import SwiftUI

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
        }
    }
#endif

struct Store {
    public let registry: Registry

    init(endpoint: String, token: String) {
        let connection = WebSocketConnection(endpoint: endpoint)
        let client = HAClient(messageExchange: connection)
        client.authenticate(
            token: token,
            onConnection: {
                client.requestRegistry()
                client.requestStates()
            },
            onFailure: { reason in
                print("Authentication failure", reason)
            }
        )
        registry = client.registry
    }
}

@main
struct HADashboardApp: App {
    #if canImport(UIKit)
        @UIApplicationDelegateAdaptor(AppDelegateAdaptor.self) private var appDelegate
    #elseif canImport(AppKit)
        @NSApplicationDelegateAdaptor(AppDelegateAdaptor.self) private var appDelegate
    #endif

    let store = Store(
        endpoint: "ws://homeassistant.raspberrypi.localdomain/api/websocket",
        token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIzNmFmZDMyMjdkYzQ0YmNlOGZiNDRhNTFiZDA4MDdkZSIsImlhdCI6MTYxMTI3MTQ2NiwiZXhwIjoxOTI2NjMxNDY2fQ.YDRag0Hvq0lrTvu4Rt_z9NAQAJJNManAP0g4wHBFRq0")

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel(store.registry))
        }
    }
}
