//
//  ImageGalleryViewModel.swift
//  ImageGallery
//
//  Created by Kartikay Rane on 28/10/25.
//

import Foundation
import SwiftUI
import Combine

class ImageGalleryViewModel: ObservableObject {
    @Published var photoModel : [PhotoModel]?
    @Published var photoCount : Int?
    
    // fetching of Images
    func fetchImages() async {
        let urlString = "https://picsum.photos/v2/list?page=1&limit=100"
        guard let url = URL(string: urlString) else { return print("Error") }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedData = try? JSONDecoder().decode([PhotoModel].self,from: data){
                photoModel = decodedData
                photoCount = decodedData.count
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}
