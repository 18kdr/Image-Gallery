//
//  HomeView.swift
//  ImageGallery
//
//  Created by Kartikay Rane on 27/10/25.
//

import SwiftUI

// MARK: - Variables
struct HomeView: View {
    let numbers = Array(0..<100)
    @ObservedObject var viewModel: ImageGalleryViewModel
    @State private var numberPass: Int = 0
    @State private var navigationVar: Bool = false
    @State var photoCount: Int?
    @State private var selectedPhoto: PhotoModel?
    let backgroundColor: [Color] = [
        Color.blue.opacity(0.3),  // Light blue
        Color.white,
        Color.blue.opacity(0.3),  // Light blue
    ]
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
    ]
}

// MARK: - Body
extension HomeView {
    var body: some View {
        VStack {
            ScrollView {
                gridView
            }
            .scrollIndicators(.hidden)
            .refreshable {
                await viewModel.fetchImages()
            }

        }
        .navigationTitle(AppStrings.homeTitle)
        .background(
            LinearGradient(
                colors: backgroundColor,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $navigationVar) {
            DetailView(
                photos: viewModel.photoModel ?? [],
                number: numberPass,
                photo: $selectedPhoto,

            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("\(AppStrings.imgCntTitle)\(viewModel.photoCount ?? 0)")
            }
        }

    }
}

// MARK: - GridView
extension HomeView {
    var gridView: some View {
        LazyVGrid(columns: columns, spacing: 1) {
            if let photo = viewModel.photoModel {
                ForEach(photo.indices, id: \.self) { idx in
                    Button {
                        selectedPhoto = photo[idx]
                        numberPass = idx
                        navigationVar = true
                    } label: {
                        AutoRetryImage(
                            photoID: photo[idx].id,
                            width: 150,
                            height: 150
                        )
                        .clipped()
                        .cornerRadius(5)
                    }
                }
            }
        }
        .padding(1)
    }
}
