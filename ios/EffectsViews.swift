import SwiftUI

struct FadeMenuView: View {
    @ObservedObject var colorManager: ColorManager
    @ObservedObject var esp32Communicator: ESP32Communicator
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isFadeOn: Bool = false
    @State private var speed: Double = 0.5
    @State private var firstColor: Color = .red
    @State private var secondColor: Color = .blue
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Włącz Fade", isOn: $isFadeOn)
                Section(header: Text("Prędkość")) {
                    Slider(value: $speed, in: 0.1...2.0)
                }
                Section(header: Text("Wybór kolorów")) {
                    HStack(spacing: 40) {
                        VStack {
                            Text("Pierwszy kolor")
                            Circle()
                                .fill(firstColor)
                                .frame(width: 50, height: 50)
                                .onLongPressGesture {
                                    firstColor = colorManager.currentSwiftUIColor
                                }
                        }
                        Spacer()
                        
                        VStack {
                            Text("Drugi kolor")
                            Circle()
                                .fill(secondColor)
                                .frame(width: 50, height: 50)
                                .onLongPressGesture {
                                    secondColor = colorManager.currentSwiftUIColor
                                }
                        }
                    }
                    Text("Przytrzymaj kółko, aby przypisać aktualny kolor.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Fade")
            .navigationBarItems(trailing: Button("Gotowe") {
                colorManager.fadeSpeed = speed
                colorManager.fadeFirstColor = firstColor
                colorManager.fadeSecondColor = secondColor
                
                if isFadeOn {
                    colorManager.startFadeEffect()
                } else {
                    colorManager.stopFadeEffect()
                }
                
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                self.speed = colorManager.fadeSpeed
                self.firstColor = colorManager.fadeFirstColor
                self.secondColor = colorManager.fadeSecondColor
                self.isFadeOn = colorManager.isFadeActive
            }
        }
    }
}

struct FadeMenuView_Previews: PreviewProvider {
    static var previews: some View {
        FadeMenuView(colorManager: ColorManager(), esp32Communicator: ESP32Communicator())
    }
}


struct PulseMenuView: View {
    @ObservedObject var colorManager: ColorManager
    @ObservedObject var esp32Communicator: ESP32Communicator
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isPulseOn: Bool = false
    @State private var speed: Double = 0.5
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Włącz Pulse", isOn: $isPulseOn)
                Section(header: Text("Prędkość")) {
                    Slider(value: $speed, in: 0.1...2.0)
                }
            }
            .navigationTitle("Pulse")
            .navigationBarItems(trailing: Button("Gotowe") {
                colorManager.pulseSpeed = speed
                
                if isPulseOn {
                    colorManager.startPulseEffect()
                } else {
                    colorManager.stopPulseEffect()
                }
                
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                self.speed = colorManager.pulseSpeed
                self.isPulseOn = colorManager.isPulseActive
            }
        }
    }
}

struct PulseMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PulseMenuView(colorManager: ColorManager(), esp32Communicator: ESP32Communicator())
    }
}
 
