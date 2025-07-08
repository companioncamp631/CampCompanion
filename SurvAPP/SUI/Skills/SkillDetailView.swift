//
//  SkillDetailView.swift
//  SurvAPP
//
//  Created by D K on 07.07.2025.
//

import Foundation
import SwiftUI

struct SkillDetailView: View {
    // Входные данные
    let skill: Skill
    let isFavorited: Bool
    
    // Замыкания для действий
    let onClose: () -> Void
    let onToggleFavorite: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Header (Back button, Title)
            
            HStack {
                Button(action: onClose) {
                    Image("icon_back_arrow") // Убедись, что у тебя есть такая картинка
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                        .colorInvert()
                        .colorMultiply(.yellow)
                }
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.bottom, -40)
            
            HStack {
                Spacer()
                Text(skill.name)
                    .font(.custom("PaytoneOne-Regular", size: 24))
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
                Spacer()
                
            }
            .padding(.horizontal)
            
            // Main Content
            HStack(alignment: .top, spacing: 16) {
                // Big Icon
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                    Image(skill.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                }
            }
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        // Favorite Button
                        Button(action: onToggleFavorite) {
                            ZStack {
                                Circle()
                                    .fill(Color.appBackground)
                                    .frame(width: 50, height: 50)
                                Image(systemName: isFavorited ? "heart.fill" : "heart")
                                    .foregroundColor(.accentYellow)
                                    .font(.system(size: 22, weight: .bold))
                                    .scaleEffect(isFavorited ? 1.1 : 1.0)
                                    .animation(.spring(), value: isFavorited)
                            }
                        }
                    }
                }
                .offset(x: 50)
            }
            
            // Long Description
            Text(skill.longDescription)
                .font(.system(size: 16))
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Share Button
            Button(action: onShare) {
                Text("Share This")
                    .font(.custom("PaytoneOne-Regular", size: 18))
                    .foregroundColor(.appBackground)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentYellow)
                    .cornerRadius(12)
            }
            
        }
        .padding(24)
        .background(Color.cardBackground)
        .cornerRadius(24)
        .shadow(radius: 20)
        .padding(.horizontal, 24) // Отступы от краев экрана
    }
}
