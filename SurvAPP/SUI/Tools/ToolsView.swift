//
//  ToolsView.swift
//  SurvAPP
//
//  Created by D K on 07.07.2025.
//

import SwiftUI

struct ToolsView: View {
    
    @State private var isRedFlashlightOn = false
    @State private var isSOSshown = false
    @State private var isCompaSshown = false
    @StateObject private var soundManager = SoundManager.shared
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        ZStack {
            // 1. Фон
            Color.appBackground.ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {dismiss()}) { // Добавь сюда свое действие для кнопки назад
                        Image("icon_back_arrow") // Убедись, что у тебя есть такая картинка
                            .resizable()
                            .scaledToFit()
                            .frame(width: 34, height: 34)
                            .colorInvert()
                            .colorMultiply(.yellow)
                    }
                    
                    Spacer()
                    
                    Text("Wilderness Tools")
                        .font(.custom("PaytoneOne-Regular", size: 28))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                 
                }
                .padding(.horizontal)
                
                VStack {
                    HStack(spacing: 25) {
                        Button {
                            isRedFlashlightOn.toggle()
                        } label: {
                            VStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.buttonBorder)
                                        .frame(width: 150, height: 150)
                                    Circle()
                                        .fill(Color.darkPurple)
                                        .frame(width: 135, height: 135)
                                    
                                    Image("iconAlert")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                }
                                Text("Red Signal Light")
                                    .foregroundStyle(.white)
                                    .font(.custom("PaytoneOne-Regular", size: 24))
                            }
                        }
                        
                        Button {
                            soundManager.toggleSound(soundName: "sosSound", loop: true)
                        } label: {
                            VStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.buttonBorder)
                                        .frame(width: 150, height: 150)
                                    Circle()
                                        .fill(Color.darkPurple)
                                        .frame(width: 135, height: 135)
                                    
                                    Image("iconSignal")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                }
                                Text("Sound \nSignal")
                                    .foregroundStyle(.white)
                                    .font(.custom("PaytoneOne-Regular", size: 24))
                            }
                        }
                    }
                    .padding(.top, 30)
                    
                    HStack(spacing: 25) {
                        Button {
                            isSOSshown.toggle()
                        } label: {
                            VStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.buttonBorder)
                                        .frame(width: 150, height: 150)
                                    Circle()
                                        .fill(Color.darkPurple)
                                        .frame(width: 135, height: 135)
                                    
                                    Image("iconFlashlight")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                }
                                Text("SOS Signal")
                                    .foregroundStyle(.white)
                                    .font(.custom("PaytoneOne-Regular", size: 24))
                            }
                        }
                        
                        Button {
                            isCompaSshown.toggle()
                        } label: {
                            VStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.buttonBorder)
                                        .frame(width: 150, height: 150)
                                    Circle()
                                        .fill(Color.darkPurple)
                                        .frame(width: 135, height: 135)
                                    
                                    Image("iconCompass")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                }
                                Text("Compass")
                                    .foregroundStyle(.white)
                                    .font(.custom("PaytoneOne-Regular", size: 24))
                            }
                        }
                    }
                    .padding(.top, 30)
                }
                
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isRedFlashlightOn) {
            RedFlashlightView()
        }
        .fullScreenCover(isPresented: $isSOSshown) {
            SOSFlashlightView()
        }
        .fullScreenCover(isPresented: $isCompaSshown) {
            MotionCompassView()
        }
    }
}

#Preview {
    ToolsView()
}
