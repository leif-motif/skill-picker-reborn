/*
 * SPRErrors.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2025 Ranger Lake Bible Camp
 *
 * Skill Picker Reborn is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Skill Picker Reborn is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Skill Picker Reborn; if not, see <https://www.gnu.org/licenses/>.
 */

import Foundation

enum SPRError: Error {
    case InvalidSize
    case NotASenior
    case NotAJunior
    case RefusingDelete
    case SkillFanaticConflict
    case NoneSkillRefusal
    case EmptySelection
    case MissingSkill
    case ReallyBadName
    case NoSkills
    case NotEnoughSkillSpace
    case DuplicateSkillName
    case SkillIsFanatic
    case InvalidFileFormat
    case UnsupportedVersion(String)
    case AmbiguousSkillEntries([String])
}
