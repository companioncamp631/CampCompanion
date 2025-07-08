//
//  SkillsViewModel.swift
//  SurvAPP
//
//  Created by D K on 07.07.2025.
//

import Foundation
import Combine

@MainActor
class SkillsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var allSkills: [Skill] = []
    @Published var filteredSkills: [Skill] = []
    @Published var selectedCategory: SkillCategory = .survival
    
    // Управляет отображением детального окна
    @Published var selectedSkill: Skill? = nil
    
    // Для хранения ID "избранных" навыков
    @Published var favoritedSkillIDs: Set<String> = []
    
    private let userDefaultsKey = "favoritedSkills"
    
    // MARK: - Initializer
    init() {
        loadSkillsFromJSON()
        loadFavorites()
        filterSkills(for: .survival)
    }
    
    // MARK: - Filtering Logic
    func filterSkills(for category: SkillCategory) {
        selectedCategory = category
        filteredSkills = allSkills.filter { $0.category == category }
    }
    
    // MARK: - Favorites Logic (UserDefaults)
    func isFavorited(skill: Skill) -> Bool {
        favoritedSkillIDs.contains(skill.id)
    }
    
    func toggleFavorite(for skill: Skill) {
        if isFavorited(skill: skill) {
            favoritedSkillIDs.remove(skill.id)
        } else {
            favoritedSkillIDs.insert(skill.id)
        }
        saveFavorites()
    }
    
    private func saveFavorites() {
        // UserDefaults не умеет хранить Set напрямую, конвертируем в Array
        let idsArray = Array(favoritedSkillIDs)
        UserDefaults.standard.set(idsArray, forKey: userDefaultsKey)
    }
    
    private func loadFavorites() {
        if let idsArray = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            favoritedSkillIDs = Set(idsArray)
        }
    }
    
    // MARK: - Data Loading
    private func loadSkillsFromJSON() {
        guard let url = Bundle.main.url(forResource: "skills", withExtension: "json") else {
            fatalError("Failed to locate skills.json in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load skills.json from bundle.")
        }
        
        do {
            let decoder = JSONDecoder()
            // Настройка для enum с rawValue
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.allSkills = try decoder.decode([Skill].self, from: data)
        } catch {
            fatalError("Failed to decode skills.json: \(error)")
        }
    }
}
