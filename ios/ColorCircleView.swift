import SwiftUI

struct ColorCircleView: View {
    var color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .overlay(Circle().stroke(Color.gray, lineWidth: 0.5))
    }
}

struct ColorCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCircleView(color: Color(hue: 0.0, saturation: 1.0, brightness: 1.0))
            .frame(width: 150, height: 150)
    }
}
