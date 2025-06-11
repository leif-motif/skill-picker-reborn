/*
 * Cabin.swift
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

class Cabin: Codable {
    var name: String
    var senior: Leader
    var junior: Leader
    var campers: Set<Camper>
    
    init(name: String, senior: Leader, junior: Leader, campers: Set<Camper> = []) throws {
        self.name = name
        if(!senior.senior){
            throw SPRError.NotASenior
        } else {
            self.senior = senior
        }
        if(junior.senior){
            throw SPRError.NotAJunior
        } else {
            self.junior = junior
        }
        self.campers = campers
    }
}
