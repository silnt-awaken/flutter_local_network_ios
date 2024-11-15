import Foundation
import Network

class LocalNetworkManager: NSObject {
    typealias AuthResult = (Bool) -> Void

    private var authResult: AuthResult?

    func requestAuthorization(completion: @escaping AuthResult) {
        authResult = completion
        if #available(iOS 14.0, *) {
            iOS14_requestAuthorization()
        } else {
            // For iOS versions below 14, local network permission is not required
            authResult?(true)
        }
    }
}

@available(iOS 14.0, *)
private extension LocalNetworkManager {
    func iOS14_requestAuthorization() {
        let browser = NetServiceBrowser()
        browser.delegate = self
        browser.searchForServices(ofType: "_http._tcp.", inDomain: "local.")
    }
}

extension LocalNetworkManager: NetServiceBrowserDelegate {
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("Found service: \(service)")
        authResult?(true)
        browser.stop()
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Failed to search: \(errorDict)")
        authResult?(false)
        browser.stop()
    }
}
