//
//  NatureViewModel.swift
//  SurvAPP
//
//  Created by D K on 08.07.2025.
//

import Foundation

//
//  SkillsViewModel.swift
//  SurvAPP
//
//  Created by D K on 07.07.2025.
//

import Foundation
import Combine

@MainActor
class NatureViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var allSkills: [Nature] = []
    @Published var filteredSkills: [Nature] = []
    @Published var selectedCategory: NatureCategory = .animalTracks
    
    // Управляет отображением детального окна
    @Published var selectedSkill: Nature? = nil
    
    // Для хранения ID "избранных" навыков
    @Published var favoritedSkillIDs: Set<String> = []
    
    private let userDefaultsKey = "favoritedNature"
    
    // MARK: - Initializer
    init() {
        loadSkillsFromJSON()
        loadFavorites()
        filterSkills(for: .animalTracks)
    }
    
    // MARK: - Filtering Logic
    func filterSkills(for category: NatureCategory) {
        selectedCategory = category
        filteredSkills = allSkills.filter { $0.category == category }
    }
    
    // MARK: - Favorites Logic (UserDefaults)
    func isFavorited(skill: Nature) -> Bool {
        favoritedSkillIDs.contains(skill.id)
    }
    
    func toggleFavorite(for skill: Nature) {
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
        guard let url = Bundle.main.url(forResource: "nature", withExtension: "json") else {
            fatalError("Failed to locate nature.json in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load nature.json from bundle.")
        }
        
        do {
            let decoder = JSONDecoder()
            // Настройка для enum с rawValue
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.allSkills = try decoder.decode([Nature].self, from: data)
        } catch {
            fatalError("Failed to decode skills.json: \(error)")
        }
    }
}
