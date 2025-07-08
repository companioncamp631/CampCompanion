//
//  Model.swift
//  SurvAPP
//
//  Created by D K on 07.07.2025.
//


import Foundation

// Enum для категорий для удобства и безопасности типов
enum SkillCategory: String, CaseIterable, Codable {
    case survival = "Survival"
    case medicine = "Medicine"
    case orientation = "Orientation"
    case shelterWater = "Shelter"
}

// Модель данных для одного навыка
struct Skill: Identifiable, Codable {
    let id: String
    let category: SkillCategory
    let name: String
    let iconName: String
    let shortDescription: String
    let longDescription: String
}


enum NatureCategory: String, CaseIterable, Codable {
    case animalTracks = "Animal Tracks"
    case terrainTypes = "Terrain Types"
}

// Модель данных для одного навыка
struct Nature: Identifiable, Codable {
    let id: String
    let category: NatureCategory
    let name: String
    let iconName: String
    let shortDescription: String
    let longDescription: String
    let imagePrompt: String
}

struct Note: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var content: String
    var date: Date
}
