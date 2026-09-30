import SwiftUI

#if canImport(UIKit)
import UIKit

extension Color {
    func toHSB() -> (hue: Double, saturation: Double, brightness: Double) {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (Double(hue), Double(saturation), Double(brightness))
    }
}
#endif

struct SavedColorsView: View {
    @ObservedObject var colorManager: ColorManager
    @State private var savedColors: [Color] = [.white, .white, .white, .white]
    
    var body: some View {
        HStack {
            ForEach(0..<savedColors.count, id: \.self) { index in
                Button(action: {
                    let hsb = savedColors[index].toHSB()
                    colorManager.hue = hsb.hue
                    colorManager.saturation = hsb.saturation
                    colorManager.brightness = hsb.brightness
                }) {
                    Circle()
                        .fill(savedColors[index])
                        .frame(width: 40, height: 40)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                .simultaneousGesture(
                    LongPressGesture().onEnded { _ in
                        savedColors[index] = colorManager.currentSwiftUIColor
                    }
                )
            }
        }
        .padding()
    }
}

struct SavedColorsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedColorsView(colorManager: ColorManager())
    }
}
