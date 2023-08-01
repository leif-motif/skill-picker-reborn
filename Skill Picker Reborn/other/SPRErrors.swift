//
//  SPRErrors.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-28.
//

import Foundation

enum SPRError: Error {
    case InvalidSize
    case NotASenior
    case NotAJunior
    case RefusingDelete
    case SkillFanaticConflict
    case SkillFull
    case NoneSkillRefusal
    case EmptySelection
}
