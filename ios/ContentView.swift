import SwiftUI

struct ContentView: View {
    @StateObject var colorManager = ColorManager()
    @StateObject var esp32Communicator = ESP32Communicator()
    
    @State private var showingSettings = false
    @State private var showingFadeMenu = false
    @State private var showingPulseMenu = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        showingSettings.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                    }
                    Spacer()
                    Toggle(isOn: $colorManager.isOn) {
                        Image(systemName: colorManager.isOn ? "power.circle.fill" : "power.circle")
                            .font(.title)
                    }
                    .labelsHidden()
                }
                .padding()
                
                ColorCircleView(color: colorManager.currentSwiftUIColor)
                    .frame(width: 150, height: 150)
                    .padding()
                
                VStack {
                    HStack {
                        Text("Odcień")
                        Slider(value: $colorManager.hue, in: 0...1)
                    }
                    HStack {
                        Text("Nasycenie")
                        Slider(value: $colorManager.saturation, in: 0...1)
                    }
                    HStack {
                        Text("Jasność")
                        Slider(value: $colorManager.brightness, in: 0...1)
                    }
                }
                .padding()
                
                BasicColorButtons(colorManager: colorManager)
                
                SavedColorsView(colorManager: colorManager)
                
                Spacer()
                
                HStack {
                    Button("Fade") {
                        showingFadeMenu.toggle()
                    }
                    .padding()
                    
                    Button("Pulse") {
                        showingPulseMenu.toggle()
                    }
                    .padding()
                }
                
                Spacer()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(esp32Communicator: esp32Communicator)
            }
            .sheet(isPresented: $showingFadeMenu) {
                FadeMenuView(colorManager: colorManager, esp32Communicator: esp32Communicator)
            }
            .sheet(isPresented: $showingPulseMenu) {
                PulseMenuView(colorManager: colorManager, esp32Communicator: esp32Communicator)
            }

            .onChange(of: colorManager.currentSwiftUIColor) { newColor in
                esp32Communicator.sendColor(newColor, brightness: colorManager.brightness)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
