//
//  Coherence.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import Foundation
import UniformTypeIdentifiers

enum ValueError: Error {
    case OutOfRange
    case InvalidValue
    case InvalidSize
    case NotASenior
    case NotAJunior
    case TooManySkills
    case RefusingDelete
    case SkillFanaticConflict
}

extension UTType {
    public static let csv = UTType(exportedAs: "com.domain.csv")
}
