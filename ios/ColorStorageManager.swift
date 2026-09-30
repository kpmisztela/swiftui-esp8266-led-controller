import Foundation

class ColorStorageManager {
    static let shared = ColorStorageManager()
    private let fileName = "savedColors.json"
    
    private var fileURL: URL? {
        let fm = FileManager.default
        guard let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return docs.appendingPathComponent(fileName)
    }
    
    func saveColors(_ colors: [RGBColor]) {
        guard let url = fileURL else { return }
        if let data = try? JSONEncoder().encode(colors) {
            try? data.write(to: url)
        }
    }
    
    func loadColors() -> [RGBColor]? {
        guard let url = fileURL, let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode([RGBColor].self, from: data)
    }
}
