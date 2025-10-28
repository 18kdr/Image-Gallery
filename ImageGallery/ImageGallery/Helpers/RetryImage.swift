//
//  RetryImage.swift
//  ImageGallery
//
//  Created by Kartikay Rane on 28/10/25.
//

import SwiftUI

// MARK: - Singleton Cache
class DiskCache {
    static let shared = DiskCache()
    private init() {}
    
    private let folder: URL = {
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache")
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }()
    
    func path(for key: String) -> URL { folder.appendingPathComponent(key) }
    
    func save(_ data: Data, for key: String) { try? data.write(to: path(for: key)) }
    
    func load(for key: String) -> UIImage? {
        let url = path(for: key)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
}

// MARK: - Cached Async Image
struct AutoRetryImage: View {
    let photoID: String
    let width: Int
    let height: Int
    
    @State private var image: Image?
    
    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .transition(.opacity)
            } else {
                Color.gray.opacity(0.2)
                    .overlay(ProgressView().scaleEffect(0.8))
                    .onAppear {
                        loadImage(width: width, height: height)        // thumbnail
                        loadImage(width: 1024, height: 1024, updateUI: false) // full-size preload
                    }
            }
        }
        .clipped()
    }
    
    private func loadImage(width: Int, height: Int, updateUI: Bool = true) {
        let key = "\(photoID)_\(width)x\(height).png"
        if let cached = DiskCache.shared.load(for: key){
            if updateUI { image = Image(uiImage: cached) }
            return
        }
        
        guard let url = URL(string: "https://picsum.photos/id/\(photoID)/\(width)/\(height)") else { return }
        
        Task {
            if let (data, _) = try? await URLSession.shared.data(from: url),
               let uiImage = UIImage(data: data) {
                
                DiskCache.shared.save(data, for: key)
                
                if updateUI {
                    await MainActor.run { image = Image(uiImage: uiImage) }
                }
            }
        }
    }
}
