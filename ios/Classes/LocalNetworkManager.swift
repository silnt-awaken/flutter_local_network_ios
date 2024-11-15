import Foundation

class LocalNetworkManager: NSObject {
    typealias AuthResult = (Bool) -> Void

    private var authResult: AuthResult?

    func requestAuthorization(completion: @escaping AuthResult) {
        self.authResult = completion
        if #available(iOS 14.0, *) {
            self.iOS14_requestAuthorization()
        } else {
            // Local network permission is not required below iOS 14
            self.authResult?(true)
        }
    }
}

@available(iOS 14.0, *)
extension LocalNetworkManager: NetServiceBrowserDelegate {
    private func iOS14_requestAuthorization() {
        let browser = NetServiceBrowser()
        browser.delegate = self
        browser.searchForServices(ofType: "_example._tcp.", inDomain: "local.")
    }

    // NetServiceBrowserDelegate methods

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("Found service: \(service)")
        browser.stop()
        authResult?(true)
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String: NSNumber]) {
        print("Search failed: \(errorDict)")
        browser.stop()
        authResult?(false)
    }

    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("Stopped browsing for services")
    }
}
