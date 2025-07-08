

import Foundation
import SwiftUI

#Preview {
    NatureSurvivalSkillsView()
}

struct NatureSurvivalSkillsView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel = NatureViewModel()
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            // 1. Фон
            Color.appBackground.ignoresSafeArea()
            
            // 2. Основной контент
            VStack(spacing: 20) {
                NatureHeaderView() {
                    dismiss()
                    print("adasda")
                }
                
                NatureFilterButtonsView(selectedCategory: $viewModel.selectedCategory) { category in
                    viewModel.filterSkills(for: category)
                }
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredSkills) { skill in
                            NatureSkillRowView(skill: skill)
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
                NatureSkillDetailView(
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
                    let textToShare = "Nature Explore: \(skill.name)\n\n\(skill.longDescription)"
                    ShareSheet(activityItems: [textToShare])
                }
            }
        }
    }
}


// MARK: - Subviews
private struct NatureHeaderView: View {
    
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
            
            Text("Nature Explore")
                .font(.custom("PaytoneOne-Regular", size: 28))
                .foregroundColor(.primaryText)
                .padding(.trailing)
            
            Spacer()
            
           
        }
        .padding(.horizontal)
    }
}

private struct NatureFilterButtonsView: View {
    @Binding var selectedCategory: NatureCategory
    var onSelect: (NatureCategory) -> Void
    
    let categories = NatureCategory.allCases
    
    var body: some View {
        // Используем Grid для удобного расположения 2x2
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                NatureFilterButton(category: .animalTracks, selectedCategory: $selectedCategory, action: onSelect)
                NatureFilterButton(category: .terrainTypes, selectedCategory: $selectedCategory, action: onSelect)
            }
         
        }
        .padding(.horizontal)
    }
}

private struct NatureFilterButton: View {
    let category: NatureCategory
    @Binding var selectedCategory: NatureCategory
    let action: (NatureCategory) -> Void
    
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


private struct NatureSkillRowView: View {
    let skill: Nature
    
    var body: some View {
        HStack(spacing: 16) {
            Image(skill.iconName) // Убедись, что есть иконки с такими именами
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
                .padding(12)
                .frame(width: 64, height: 64)
                .background(Color.appBackground)
                .cornerRadius(16)
            
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






import Foundation
import SwiftUI

struct NatureSkillDetailView: View {
    // Входные данные
    let skill: Nature
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
                        .cornerRadius(16)
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
