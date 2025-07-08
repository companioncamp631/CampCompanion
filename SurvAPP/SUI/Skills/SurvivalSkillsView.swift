//
//  SurvivalSkillsView.swift
//  SurvAPP
//
//  Created by D K on 07.07.2025.
//

import Foundation
import SwiftUI

struct SurvivalSkillsView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel = SkillsViewModel()
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            // 1. Фон
            Color.appBackground.ignoresSafeArea()
            
            // 2. Основной контент
            VStack(spacing: 20) {
                HeaderView() {
                    dismiss()
                    print("adasda")
                }
                
                FilterButtonsView(selectedCategory: $viewModel.selectedCategory) { category in
                    viewModel.filterSkills(for: category)
                }
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredSkills) { skill in
                            SkillRowView(skill: skill)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        viewModel.selectedSkill = skill
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
            
            // 3. Кастомное модальное окно (появляется поверх)
            if let skill = viewModel.selectedSkill {
                // Затемнение фона
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            viewModel.selectedSkill = nil
                        }
                    }
                
                // Само окно
                SkillDetailView(
                    skill: skill,
                    isFavorited: viewModel.isFavorited(skill: skill),
                    onClose: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            viewModel.selectedSkill = nil
                        }
                    },
                    onToggleFavorite: {
                        viewModel.toggleFavorite(for: skill)
                    },
                    onShare: {
                        self.showShareSheet = true
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .sheet(isPresented: $showShareSheet) {
                    let textToShare = "Survival Skill: \(skill.name)\n\n\(skill.longDescription)"
                    ShareSheet(activityItems: [textToShare])
                }
            }
        }
    }
}


// MARK: - Subviews
private struct HeaderView: View {
    
    var completion: () -> ()
    
    var body: some View {
        HStack {
            Button(action: {completion()}) { // Добавь сюда свое действие для кнопки назад
                Image("icon_back_arrow") // Убедись, что у тебя есть такая картинка
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 34, height: 34)
                                            .colorInvert()
                                            .colorMultiply(.yellow)
            }
            
            Spacer()
            
            Text("Survival Skills")
                .font(.custom("PaytoneOne-Regular", size: 28))
                .foregroundColor(.primaryText)
                .padding(.trailing)
            
            Spacer()
            
           
        }
        .padding(.horizontal)
    }
}

private struct FilterButtonsView: View {
    @Binding var selectedCategory: SkillCategory
    var onSelect: (SkillCategory) -> Void
    
    let categories = SkillCategory.allCases
    
    var body: some View {
        // Используем Grid для удобного расположения 2x2
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                FilterButton(category: .survival, selectedCategory: $selectedCategory, action: onSelect)
                FilterButton(category: .medicine, selectedCategory: $selectedCategory, action: onSelect)
            }
            GridRow {
                FilterButton(category: .orientation, selectedCategory: $selectedCategory, action: onSelect)
                FilterButton(category: .shelterWater, selectedCategory: $selectedCategory, action: onSelect)
            }
        }
        .padding(.horizontal)
    }
}

private struct FilterButton: View {
    let category: SkillCategory
    @Binding var selectedCategory: SkillCategory
    let action: (SkillCategory) -> Void
    
    var isSelected: Bool {
        category == selectedCategory
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                action(category)
            }
        }) {
            Text(category.rawValue.replacingOccurrences(of: " ", with: " \n& "))
                .font(.custom("PaytoneOne-Regular", size: 16))
                .foregroundColor(isSelected ? .appBackground : .primaryText)
                .frame(maxWidth: .infinity, minHeight: 60)
                .multilineTextAlignment(.center)
                .background(isSelected ? Color.accentYellow : Color.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.buttonBorder, lineWidth: 1)
                )
        }
    }
}


private struct SkillRowView: View {
    let skill: Skill
    
    var body: some View {
        HStack(spacing: 16) {
            Image(skill.iconName) // Убедись, что есть иконки с такими именами
                .resizable()
                .scaledToFit()
                .padding(12)
                .frame(width: 64, height: 64)
                .background(Color.appBackground)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(skill.name)
                    .font(.custom("PaytoneOne-Regular", size: 18))
                    .foregroundColor(.primaryText)
                
                Text(skill.shortDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.cardBackground)
        .cornerRadius(16)
    }
}


struct SurvivalSkillsView_Previews: PreviewProvider {
    static var previews: some View {
        SurvivalSkillsView()
    }
}
