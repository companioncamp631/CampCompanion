//
//  SwiftUIView.swift
//  SurvAPP
//
//  Created by D K on 07.07.2025.
//

import SwiftUI

struct RedFlashlightView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var initialBrightness: CGFloat = UIScreen.main.brightness
    @State private var brightness: CGFloat = UIScreen.main.brightness
    @State private var isAlertPresented: Bool = false

    var body: some View {
        ZStack {
            // Красный фон на весь экран
            Color.red
                .ignoresSafeArea()

            // Ползунок управления яркостью
            VStack {
                Spacer()
                Slider(value: Binding(
                    get: { self.brightness },
                    set: {
                        self.brightness = $0
                        UIScreen.main.brightness = $0
                    }
                ), in: 0...1)
                .padding()
                .accentColor(.white)
            }
            
            VStack {
                
                HStack {
                    Button(action: {dismiss()}) {
                        Image("icon_back_arrow") // Убедись, что у тебя есть такая картинка
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 34, height: 34)
                                                    .colorInvert()
                                                    .colorMultiply(.yellow)
                    }
                    
                    Spacer()
                    
                    Button {
                        isAlertPresented.toggle()
                    } label: {
                        Image(systemName: "circle.badge.questionmark")
                    }
                    .foregroundStyle(.white)
                }
             
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear {
            brightness = UIScreen.main.brightness
            
        }
        .onDisappear {
            UIScreen.main.brightness = initialBrightness
        }
        .alert("A red flashlight is used to preserve night vision, avoid startling animals, and reduce glare in the dark.", isPresented: $isAlertPresented) {
            Text("Ok")
        }
    }
}

#Preview {
    RedFlashlightView()
}
