import Foundation
import SwiftUI
import Connect4Core
import Connect4Persistance

public extension Persistance {
    static func loadImage(withName fileName: String, withFolderName folderName: String) async throws -> (image: Image?, path: String) {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(folderName) {
            let filePath = path.appending(path: "\(fileName).png")
            if FileManager.default.fileExists(atPath: filePath.path) {
                if let uiImage = UIImage(contentsOfFile: filePath.path) {
                    return (image: Image(uiImage: uiImage), filePath.path)
                }
            }
        }
        return (image: nil, path: "")
    }
    
    static func saveImage(_ image: Image, withName fileName: String, withFolderName folderName: String) async throws -> String? {
        guard let data = try? image.asUIImage().pngData() else {
            print("Could not convert image to PNG data")
            return nil
        }
        
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(folderName) {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            
            let filePath = path.appending(path: "\(fileName).png")
            if !FileManager.default.fileExists(atPath: filePath.path) {
                _ = FileManager.default.createFile(atPath: filePath.path, contents: nil)
            }
            
            do {
                try data.write(to: filePath)
                print("Saved at \(filePath)")
                return filePath.path
            } catch {
                print("Error saving image: \(error)")
            }
        }
        return nil
    }
}
