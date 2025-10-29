//
//  DetailView.swift
//  ImageGallery
//
//  Created by Kartikay Rane on 27/10/25.
//

import SwiftUI


// MARK: - Variables
struct DetailView: View {
    let photos: [PhotoModel]
    @State var number: Int
    @Binding var photo : PhotoModel?
    @State var indexImg : Int = 0
    let backgroundColor : [Color] = [
        Color.orange.opacity(0.3),
        Color.white,
        Color.orange.opacity(0.3)
    ]
    @State var isIpad = UIDevice.current.userInterfaceIdiom == .pad
}

// MARK: - Body
extension DetailView{
    var body: some View {
        VStack(spacing: 0){
            tabView
        }
        .background(
            LinearGradient(
                colors: backgroundColor,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("\(AppStrings.detailViewImageNumber)\(number + 1)")
            }
        }
    }
}

// MARK: - TabView
extension DetailView{
    var tabView : some View{
        TabView(selection: $number){
            imageView
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationTitle(AppStrings.detailTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - ImageView
extension DetailView{
    var imageView: some View{
        ForEach(photos.indices, id: \.self) { index in
            VStack {
                VStack{
                    if let diskUIImage = DiskCache.shared.load(for: "\(photos[index].id)_1024x1024.png") {
                        Image(uiImage: diskUIImage)
                            .resizable()
                            .scaledToFit()
                    }else{
                        AutoRetryImage(photoID: photos[index].id, width: 1024, height: 1024)
                    }
                    Text("\(AppStrings.detailViewImageTitle)\(photos[index].author)")
                        .font(.system(size: isIpad ? 28 : 14))
                }
                .frame(height: isIpad ? 600 : 300)
            }
            .tag(index)
            .padding()
        }
    }
}
