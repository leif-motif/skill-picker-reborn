//
//  Coherence.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import Foundation

let validCabins: [String] = ["Unassigned","A","B","C","D","E","F","1","2","3","4","5"]
enum ValueError: Error {
    case OutOfRange
    case InvalidValue
    case InvalidSize
    case NotASenior
    case NotAJunior
    case TooManySkills
}

enum Flavor: String, CaseIterable, Identifiable {
    case chocolate, vanilla, strawberry
    var id: Self { self }
}
