import Foundation

struct RGBColor: Codable {
    var r: Int
    var g: Int
    var b: Int
}

struct ColorConverter {
    static func hsbToRgb(hue: Double, saturation: Double, brightness: Double) -> RGBColor {
        let i = Int(hue * 6)
        let f = hue * 6 - Double(i)
        let p = brightness * (1 - saturation)
        let q = brightness * (1 - f * saturation)
        let t = brightness * (1 - (1 - f) * saturation)
        
        var r: Double, g: Double, b: Double
        switch i % 6 {
        case 0: r = brightness; g = t; b = p
        case 1: r = q; g = brightness; b = p
        case 2: r = p; g = brightness; b = t
        case 3: r = p; g = q; b = brightness
        case 4: r = t; g = p; b = brightness
        case 5: r = brightness; g = p; b = q
        default:
            r = brightness; g = t; b = p
        }
        return RGBColor(r: Int(r * 255), g: Int(g * 255), b: Int(b * 255))
    }
}
