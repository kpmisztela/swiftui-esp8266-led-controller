import SwiftUI

struct BasicColorButtons: View {
    @ObservedObject var colorManager: ColorManager
    
    var body: some View {
        HStack {
            Button(action: {
                colorManager.hue = 0.0
                colorManager.saturation = 1.0
                colorManager.brightness = 1.0
            }) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 40, height: 40)
            }
            Button(action: {
                colorManager.hue = 0.333
                colorManager.saturation = 1.0
                colorManager.brightness = 1.0
            }) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 40, height: 40)
            }
            Button(action: {
                colorManager.hue = 0.666
                colorManager.saturation = 1.0
                colorManager.brightness = 1.0
            }) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
            }
            Button(action: {
                colorManager.hue = 0.0
                colorManager.saturation = 0.0
                colorManager.brightness = 1.0
            }) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }
        }
        .padding()
    }
}

struct BasicColorButtons_Previews: PreviewProvider {
    static var previews: some View {
        BasicColorButtons(colorManager: ColorManager())
    }
}
