import SwiftUI

struct SettingsView: View {
    @ObservedObject var esp32Communicator: ESP32Communicator
    @Environment(\.presentationMode) var presentationMode
    @State private var ipInput: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Adres IP ESP32")) {
                    TextField("192.168.1.xxx", text: $ipInput)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Ustawienia")
            .navigationBarItems(trailing: Button("Zapisz") {
                esp32Communicator.ipAddress = ipInput
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                ipInput = esp32Communicator.ipAddress
            }
        }
    }
}
