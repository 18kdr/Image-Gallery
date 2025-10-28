//
//  LaunchView.swift
//  ImageGallery
//
//  Created by Kartikay Rane on 28/10/25.
//

import SwiftUI

// MARK: - Variables
struct LaunchView: View {
    @State private var displayedText = ""
    @State private var showButton = false
    @State private var navigationVar = false
    @StateObject private var viewModel = ImageGalleryViewModel()
    let backgroundColor : [Color] = [Color.yellow.opacity(0.3), // Light blue
        Color.white,
        Color.yellow.opacity(0.3)]  // Light blue
}

// MARK: - Body
extension LaunchView{
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                logoView
                Spacer()
            }
            .ignoresSafeArea(.all)
            .navigationDestination(isPresented: $navigationVar) {
                HomeView(viewModel: viewModel, photoCount: viewModel.photoCount)
            }
            .background(
                LinearGradient(
                    colors: backgroundColor,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
        .onAppear {
            startTypingAnimation()
            Task {
                await viewModel.fetchImages()
            }
        }
    }
}

//MARK: - Logo View
extension LaunchView{
    var logoView: some View{
        VStack {
            Spacer()
            VStack{
                Image("Image")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
            }
            .animation(.bouncy(extraBounce: 0.5), value: showButton)
            Text(displayedText)
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            if showButton {
                Button {
                    navigationVar = true
                } label: {
                    Text(AppStrings.clickMeBtn)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .padding(.top, 30)
            }
            Spacer()
        }
    }
}

// MARK: - Typing Animation
extension LaunchView{
    func startTypingAnimation() {
        displayedText = ""
        showButton = false
        
        let characters = Array(AppStrings.appTitle)
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if index < characters.count {
                displayedText.append(characters[index])
                index += 1
            } else {
                timer.invalidate()
                withAnimation(.easeInOut.delay(0.3)) {
                    showButton = true
                }
            }
        }
    }
}

