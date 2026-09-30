# SwiftUI ESP8266 LED Controller

iOS application built with SwiftUI for controlling LED color and brightness over Wi-Fi through an ESP8266 HTTP server.

The project combines a SwiftUI mobile interface with an ESP8266-based HTTP communication layer using JSON messages.

## Features

- HSB color control with hue, saturation and brightness sliders
- Real-time color preview
- Quick selection of red, green, blue and white
- Four customizable saved-color slots
- Fade effect between two selected colors
- Pulse brightness effect
- Adjustable effect speed
- ESP8266 IP address configuration
- Wi-Fi communication between the iOS application and ESP8266
- HTTP POST communication with JSON payloads
- HTTP GET endpoint for reading the latest received values

## User Interface

### Main Screen

![Main screen](images/main.png)

The main screen provides the primary color control interface, including HSB sliders, color preview, basic color presets and saved-color slots.

### Fade Effect

![Fade effect](images/fade.png)

The Fade interface allows two colors to be selected and the transition speed to be adjusted.

### Pulse Effect

![Pulse effect](images/pulse.png)

The Pulse interface provides control over the brightness pulsing effect and its speed.

## System Architecture

```text
┌──────────────────────────┐
│         iOS App          │
│         SwiftUI          │
│                          │
│  Color Selection         │
│  Brightness Control      │
│  Fade / Pulse Effects    │
│  Saved Colors            │
│  IP Configuration        │
└────────────┬─────────────┘
             │
             │ Wi-Fi
             │ HTTP / JSON
             ▼
┌──────────────────────────┐
│         ESP8266          │
│       HTTP Server        │
│                          │
│   POST /setColor         │
│   GET  /                 │
└──────────────────────────┘
```

## How It Works

The user selects a color and brightness in the SwiftUI application.

The selected HSB color is converted into RGB values and sent to the ESP8266 as a JSON object through an HTTP POST request.

```text
HSB Color
    │
    ▼
HSB → RGB Conversion
    │
    ▼
JSON Payload
    │
    ▼
HTTP POST /setColor
    │
    ▼
ESP8266
```

The ESP8266 parses the received JSON data and stores the latest RGB values, brightness and device state.

The `GET /` endpoint returns the currently stored values as plain text.

## Color Management

The application represents colors internally using HSB values:

- Hue
- Saturation
- Brightness

The selected color is displayed directly in the interface and converted to RGB values before transmission to the ESP8266.

RGB values are represented in the `0–255` range.

## Basic Color Selection

The application provides predefined buttons for:

- Red
- Green
- Blue
- White

Selecting one of these buttons immediately updates the current HSB color values.

## Saved Colors

The application provides four customizable color slots.

A long press stores the currently selected color in a slot, while tapping a slot restores the stored color to the main color controls.

Saved colors are maintained in the current application state.

## Fade Effect

The Fade effect gradually changes the color between two selected colors.

The user can:

- enable or disable the effect
- select the first color
- select the second color
- adjust the transition speed

The effect is implemented using a timer running at 50 ms intervals and interpolates the HSB components between the two selected colors.

## Pulse Effect

The Pulse effect continuously changes the brightness of the selected color.

The user can:

- enable or disable the effect
- adjust the pulse speed

The brightness oscillates between the defined minimum and maximum values while keeping the hue and saturation unchanged.

## ESP8266 Communication

The `ESP8266Communicator.swift` class handles communication between the iOS application and the ESP8266.

The application sends an HTTP `POST` request to:

```text
/setColor
```

with a JSON payload containing:

```json
{
    "r": 255,
    "g": 0,
    "b": 0,
    "brightness": 1.0,
    "isOn": true
}
```

The ESP8266 receives the request, validates the JSON data and stores the received parameters.

The firmware also provides:

```text
GET /
POST /setColor
```

The `GET /` endpoint returns the latest received RGB values, brightness and processing status.

## Firmware

The ESP8266 firmware uses:

- `ESP8266WiFi`
- `ESP8266WebServer`
- `ArduinoJson`

The device connects to a Wi-Fi network and starts an HTTP server on port 80.

The firmware parses incoming JSON requests and stores the latest received parameters for further processing.

## iOS Application Structure

The SwiftUI application is divided into several components:

```text
ios/
├── BasicColorButtons.swift
├── ColorCircleView.swift
├── ColorConverter.swift
├── ColorManager.swift
├── ColorStorageManager.swift
├── ContentView.swift
├── EffectsViews.swift
├── ESP8266Communicator.swift
├── Pilot_LEDApp.swift
├── SavedColorsView.swift
└── SettingsView.swift
```

### `ContentView.swift`

Main application interface.

Provides:

- color preview
- HSB sliders
- basic color selection
- saved colors
- Fade menu
- Pulse menu
- application settings

### `ColorManager.swift`

Central state and effect management.

Responsible for:

- current HSB color
- brightness
- Fade effect
- Pulse effect
- effect speed
- effect state

### `ColorConverter.swift`

Converts HSB color values into RGB components used for communication with the ESP8266.

### `ESP8266Communicator.swift`

Handles HTTP communication with the ESP8266 server and creates the JSON request sent to `/setColor`.

### `EffectsViews.swift`

Contains the user interfaces for configuring the Fade and Pulse effects.

### `SavedColorsView.swift`

Implements the four customizable color slots and color restoration using HSB conversion.

### `SettingsView.swift`

Allows the user to change the IP address of the ESP8266 device.

## Technologies

- Swift
- SwiftUI
- iOS
- C++
- Arduino framework
- ESP8266
- Wi-Fi
- HTTP
- JSON
- HSB / RGB color conversion
- IoT

## Project Structure

```text
swiftui-esp8266-led-controller/
├── README.md
├── .gitignore
├── ios/
│   ├── BasicColorButtons.swift
│   ├── ColorCircleView.swift
│   ├── ColorConverter.swift
│   ├── ColorManager.swift
│   ├── ColorStorageManager.swift
│   ├── ContentView.swift
│   ├── EffectsViews.swift
│   ├── ESP8266Communicator.swift
│   ├── Pilot_LEDApp.swift
│   ├── SavedColorsView.swift
│   └── SettingsView.swift
├── firmware/
│   └── ESP8266_LED_Controller.ino
└── images/
    ├── main.png
    ├── fade.png
    └── pulse.png
```

## Project Status

Completed application and ESP8266 communication prototype.

The iOS application provides color management and lighting effects, while the ESP8266 implements the Wi-Fi and HTTP/JSON communication layer.

## My Contribution

This was an individual project.

I designed and implemented the complete application and communication layer, including:

- SwiftUI user interface
- HSB color management
- HSB to RGB conversion
- saved-color slots
- Fade effect
- Pulse effect
- ESP8266 HTTP server
- JSON communication between the iOS application and ESP8266
- IP address configuration
- application and firmware integration

## Possible Improvements

- Implement direct LED strip control on the ESP8266
- Connect the application power switch to the transmitted `isOn` state
- Add persistent storage for saved colors
- Add connection status and error handling in the iOS interface
- Add support for multiple ESP8266 devices
- Replace the hard-coded IP address with device discovery

## Author

**Konrad Misztela**