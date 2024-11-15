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
        // Replace with your router's IP address
        let hostIP = "10.0.0.1"
        let urlString = "http://\(hostIP)/"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            authResult?(false)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("HTTP request failed: \(error)")
                DispatchQueue.main.async {
                    self?.authResult?(false)
                }
                return
            }

            print("HTTP request succeeded")
            DispatchQueue.main.async {
                self?.authResult?(true)
            }
        }

        task.resume()
    }
}
