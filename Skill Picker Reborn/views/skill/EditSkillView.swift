/*
 * EditSkillView.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2023 Ranger Lake Bible Camp
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

import SwiftUI

struct EditSkillView: View {
    @EnvironmentObject private var data: CampData
    @State private var newName: String = ""
    @State private var newMaximums: [Int] = [0,0,0,0]
    private var targetSkill: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            
        }
        .onAppear(perform: {
            newName = targetSkill
            newMaximums = data.skills[targetSkill]!.maximums
        })
    }
    init(targetSkill: String) throws {
        if(targetSkill == "None"){
            throw SPRError.NoneSkillRefusal
        }
        self.targetSkill = targetSkill
    }
}

struct EditSkillView_Previews: PreviewProvider {
    static var previews: some View {
        try! EditSkillView(targetSkill: "Mario")
            .environmentObject(CampData())
    }
}
