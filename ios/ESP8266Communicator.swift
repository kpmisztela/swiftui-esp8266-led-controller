import SwiftUI

class ESP32Communicator: ObservableObject {
    @Published var ipAddress: String = "172.20.10.14"
    
    func sendColor(_ color: Color, brightness: Double) {
        guard let url = URL(string: "http://\(ipAddress)/setColor") else { return }
        
        #if canImport(UIKit)
        let uiColor = UIColor(color)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #else
        let red: CGFloat = 1.0, green: CGFloat = 1.0, blue: CGFloat = 1.0
        #endif
        
        let parameters: [String: Any] = [
            "r": Int(red * 255),
            "g": Int(green * 255),
            "b": Int(blue * 255),
            "brightness": brightness,
            "isOn": true
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Błąd wysyłania: \(error.localizedDescription)")
            } else {
                print("Kolor wysłany do ESP32")
            }
        }.resume()
    }
}
