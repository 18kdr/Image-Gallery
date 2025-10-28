//
//  PhotoModel.swift
//  ImageGallery
//
//  Created by Kartikay Rane on 28/10/25.
//

import Foundation

struct PhotoModel: Codable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
