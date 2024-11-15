// LocalNetworkManager.swift

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
        // Replace this IP address with a known device on your local network
        let hostIP = "10.0.0.1" // Example IP address
        let port: UInt16 = 80 // Common port; adjust as necessary

        guard let portEndpoint = NWEndpoint.Port(rawValue: port) else {
            print("Invalid port number")
            authResult?(false)
            return
        }

        let host = NWEndpoint.Host(hostIP)
        let parameters = NWParameters.tcp
        parameters.includePeerToPeer = true

        let connection = NWConnection(host: host, port: portEndpoint, using: parameters)

        connection.stateUpdateHandler = { [weak self] newState in
            switch newState {
            case .setup:
                print("Connection: Setup")
            case .waiting(let error):
                print("Connection: Waiting (\(error))")
            case .preparing:
                print("Connection: Preparing")
            case .ready:
                print("Connection: Ready")
                print("Local network permission granted")
                self?.authResult?(true)
                connection.cancel()
            case .failed(let error):
                print("Connection: Failed (\(error))")
                self?.authResult?(false)
                connection.cancel()
            case .cancelled:
                print("Connection: Cancelled")
            default:
                break
            }
        }

        connection.start(queue: .main)
    }
}
