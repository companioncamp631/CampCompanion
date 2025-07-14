//
//  MainView.swift
//  SurvAPP
//
//  Created by D K on 07.07.2025.
//

import SwiftUI


struct MainView: View {
    
    @State private var isToolsPresented: Bool = false
    @State private var isSkillsPresented: Bool = false
    @State private var isNaturePresented: Bool = false
    @State private var isNotesPresented: Bool = false
    
    @StateObject private var viewModel = SurvivalViewModel()
    @State private var isOnboardingShown: Bool = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(width: size().width, height: size().height)
                .ignoresSafeArea()
            
            VStack {
                if viewModel.isTextShown {
                    Image("iconCloud")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .overlay {
                            Text(viewModel.textToShown)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                                .font(.custom("PaytoneOne-Regular", size: 16))
                                .offset(y: -20)
                        }
                        .padding(.top, 120)
                        .padding(.trailing, 120)
                }
                
                Spacer()
                
            }
            
            VStack {
                Text("Survival \nHub")
                    .foregroundStyle(.white)
                    .font(.custom("PaytoneOne-Regular", size: 24))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(.top, size().height > 667 ? 40 : 0)
            
            
            VStack {
                Spacer()
                
                HStack {
                    Button {
                        isSkillsPresented.toggle()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color.lightPurple, Color.darkPurple], startPoint: .top, endPoint: .bottom))
                                .frame(width: 70, height: 70)
                            
                            Image("icon1")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        isNotesPresented.toggle()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color.lightPurple, Color.darkPurple], startPoint: .top, endPoint: .bottom))
                                .frame(width: 70, height: 70)
                            
                            Image("icon3")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        isToolsPresented.toggle()
                        
                    } label: {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color.lightPurple, Color.darkPurple], startPoint: .top, endPoint: .bottom))
                                .frame(width: 70, height: 70)
                            
                            Image("icon2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        isNaturePresented.toggle()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color.lightPurple, Color.darkPurple], startPoint: .top, endPoint: .bottom))
                                .frame(width: 70, height: 70)
                            
                            Image("icon4")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.bottom, 50)
        }
        .fullScreenCover(isPresented: $isSkillsPresented) {
            SurvivalSkillsView()
        }
        .fullScreenCover(isPresented: $isToolsPresented) {
            ToolsView()
        }
        .fullScreenCover(isPresented: $isNaturePresented) {
            NatureSurvivalSkillsView ()
        }
        .fullScreenCover(isPresented: $isNotesPresented) {
            NotesListView()
        }
        .fullScreenCover(isPresented: $isOnboardingShown){
            OnboardingView {
                isOnboardingShown.toggle()
            }
        }
        .onAppear {
            if !UserDefaults.standard.bool(forKey: "first") {
                isOnboardingShown.toggle()
                UserDefaults.standard.set(true, forKey: "first")
            }
            viewModel.startQuoteLoop()
        }
        .onDisappear {
            viewModel.stopQuoteLoop()
        }
        .onAppear {
            AppDelegate.orientationLock = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
    
    
    
}

#Preview {
    MainView()
}


extension View {
    func size() -> CGSize {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds.size
    }
}

class SurvivalViewModel: ObservableObject {
    @Published var isTextShown = false
    @Published var textToShown = ""
    
    private let survivalQuotes: [String] = [
        "Stay calm, stay alive.",
        "Nature tests, but you endure.",
        "One step at a time. Always forward.",
        "You have what it takes.",
        "Adapt. Improvise. Overcome.",
        "Breathe. Focus. Survive.",
        "The wild fears the prepared.",
        "Strength is born in struggle.",
        "Mind sharp. Spirit stronger.",
        "Every sunrise is a second chance."
    ]
    
    private var currentIndex = 0
    private var timer: Timer?
    
    func startQuoteLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            withAnimation {
                self.isTextShown.toggle()
                self.textToShown = self.survivalQuotes[self.currentIndex]
                self.currentIndex = (self.currentIndex + 1) % self.survivalQuotes.count
            }
            
        }
    }
    
    func stopQuoteLoop() {
        timer?.invalidate()
        timer = nil
    }
}
