import Foundation
import Network


class LocalNetworkManager: NSObject {
    typealias AuthResult = (Bool) -> Void
    
    private
    var authResult: AuthResult?
    
    private
    var netService: NetService?
    
    func requestAuthorization(completion: AuthResult?) {
        authResult = completion
        guard #available(iOS 14, *) else {
            authResult?(true)
            return
        }
        iOS14_requestAuthorization()
    }
}

private var gBrowserKey: Void?
private var gNWConnectionKey: Void?

@available(iOS 14.0, *)
private
extension LocalNetworkManager {
    private
    var browser: NWBrowser? {
        get {
            objc_getAssociatedObject(self, &gBrowserKey) as? NWBrowser
        }
        set {
            objc_setAssociatedObject(self, &gBrowserKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func iOS14_requestAuthorization() {
        let type = "_paperang._tcp"
        // Create parameters, and allow browsing over peer-to-peer link.
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
        // Browse for a custom service type.
        let browser = NWBrowser(for: .bonjour(type: type, domain: nil), using: parameters)
        self.browser = browser
        browser.stateUpdateHandler = { newState in
            switch newState {
            case .failed(let error):
                print(error.localizedDescription)
            case .ready, .cancelled:
                break
            case let .waiting(error):
                print(error.localizedDescription)

                self.reset()
                self.authResult?(false)
            default:
                break
            }
        }
        
        self.netService = NetService(domain: "local.", type: type, name: "LocalNetworkPrivacy", port: 1100)
        self.netService?.delegate = self
        
        self.browser?.start(queue: .main)
        self.netService?.publish()
    }
    
    func reset() {
        self.browser?.cancel()
        self.browser = nil
        self.netService?.stop()
        self.netService = nil
    }
}

@available(iOS 14.0, *)
extension LocalNetworkManager : NetServiceDelegate {
    func netServiceDidPublish(_ sender: NetService) {
       
        self.reset()
        self.authResult?(true)
    }
}
