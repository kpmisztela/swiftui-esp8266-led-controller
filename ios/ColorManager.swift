import SwiftUI

class ColorManager: ObservableObject {

    @Published var hue: Double = 0.0
    @Published var saturation: Double = 1.0
    @Published var brightness: Double = 1.0
    @Published var isOn: Bool = true
    
    @Published var isFadeActive: Bool = false
    @Published var fadeSpeed: Double = 0.5
    @Published var fadeFirstColor: Color = .red
    @Published var fadeSecondColor: Color = .blue
    
    @Published var isPulseActive: Bool = false
    @Published var pulseSpeed: Double = 0.5
    
    var currentSwiftUIColor: Color {
        Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    private var fadeTimer: Timer?
    private var fadeProgress: Double = 0.0
    private var fadeDirection: Double = 1.0
    
    func startFadeEffect() {
        isFadeActive = true
        fadeTimer?.invalidate()
        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self = self, self.isFadeActive else {
                timer.invalidate()
                return
            }
            
            self.fadeProgress += self.fadeDirection * self.fadeSpeed * 0.05
            if self.fadeProgress >= 1.0 {
                self.fadeProgress = 1.0
                self.fadeDirection = -1.0
            } else if self.fadeProgress <= 0.0 {
                self.fadeProgress = 0.0
                self.fadeDirection = 1.0
            }
            
            let firstHSB = self.fadeFirstColor.toHSB()
            let secondHSB = self.fadeSecondColor.toHSB()
            
            let newHue = firstHSB.hue + self.fadeProgress * (secondHSB.hue - firstHSB.hue)
            let newSaturation = firstHSB.saturation + self.fadeProgress * (secondHSB.saturation - firstHSB.saturation)
            let newBrightness = firstHSB.brightness + self.fadeProgress * (secondHSB.brightness - firstHSB.brightness)
            
            DispatchQueue.main.async {
                self.hue = newHue
                self.saturation = newSaturation
                self.brightness = newBrightness
            }
        }
    }
    
    func stopFadeEffect() {
        isFadeActive = false
        fadeTimer?.invalidate()
        fadeTimer = nil
    }
    
    private var pulseTimer: Timer?
    private var pulseIncreasing: Bool = true
    
    func startPulseEffect() {
        isPulseActive = true
        pulseTimer?.invalidate()
        pulseTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self = self, self.isPulseActive else {
                timer.invalidate()
                return
            }
            
            let delta = self.pulseSpeed * 0.05
            if self.pulseIncreasing {
                self.brightness += delta
                if self.brightness >= 1.0 {
                    self.brightness = 1.0
                    self.pulseIncreasing = false
                }
            } else {
                self.brightness -= delta
                if self.brightness <= 0.3 {
                    self.brightness = 0.3
                    self.pulseIncreasing = true
                }
            }
        }
    }
    
    func stopPulseEffect() {
        isPulseActive = false
        pulseTimer?.invalidate()
        pulseTimer = nil
    }
}
