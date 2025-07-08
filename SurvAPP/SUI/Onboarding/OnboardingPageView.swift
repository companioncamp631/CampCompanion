//
//  OnboardingPageView.swift
//  SurvAPP
//
//  Created by D K on 08.07.2025.
//

import Foundation

// OnboardingPageView.swift
import SwiftUI

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 20) {
            // MARK: Character Image
            ZStack {
                Circle()
                    .fill(Color.primaryButton)
                    .frame(width: 250, height: 250)

                Image(imageName)
                    .resizable()
                    .frame(width: 250, height: 260)
                    .clipShape(Circle())
                    
            }
            .padding(.bottom, 10)

            // MARK: Text Content
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(description)
                .font(.body)
                .foregroundStyle(Color.lightPurpleText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

// OnboardingView.swift
import SwiftUI

struct OnboardingView: View {
    // Эта функция будет вызвана, когда онбординг завершится
    var onComplete: () -> Void

    @State private var currentPage = 0
    private let totalPages = 2

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack {
                // MARK: Page View
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "onb1",
                        title: "Welcome, Explorer",
                        description: "Your guide to understanding nature. Learn survival skills, identify plants and animals, and use handy tools on your adventures."
                    )
                    .tag(0)

                    OnboardingPageView(
                        imageName: "onb2",
                        title: "Know Your Nature!",
                        description: "This app is designed for educational and entertainment purposes. The information within is a starting point for learning. For real-world situations, always rely on expert training and official safety guidelines."
                    )
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // MARK: Custom Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.accentYellow : Color.white.opacity(0.5))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 30)

                // MARK: Bottom Buttons
                bottomButtonArea
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
            }
        }
    }

    @ViewBuilder
    private var bottomButtonArea: some View {
        if currentPage == 0 {
            HStack {
                
                
                Spacer()
                
                Button("NEXT") {
                    currentPage = 1
                }
                .foregroundStyle(Color.accentYellow)
                .fontWeight(.bold)
            }
        } else {
            Button("START") {
                completeOnboarding()
            }
            .buttonStyle(AccentButtonStyle())
        }
    }
    
    private func completeOnboarding() {
        // Устанавливаем флаг, что онбординг пройден
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        onComplete()
    }
}
