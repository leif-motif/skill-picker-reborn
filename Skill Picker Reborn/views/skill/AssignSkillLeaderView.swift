/*
 * AssignSkillLeaderView.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2024 Ranger Lake Bible Camp
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

struct AssignSkillLeaderView: View {
    @EnvironmentObject private var data: CampData
    private let targetSkill: String
    private let skillPeriod: Int
    @State private var leaderInput = ""
    @State private var leaderIDs: [String:Leader.ID] = [:]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Leader:", text: $leaderInput)
                .padding(.bottom)
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Leader") {
                    data.assignLeaderToSkill(targetLeader: data.getLeader(leaderID: leaderIDs[leaderInput.lowercased()]!)!, skillName: targetSkill, period: skillPeriod)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(!leaderIDs.keys.contains(leaderInput.lowercased()))
            }
        }
        .padding()
        .frame(width: 270, height: 90)
        .onAppear(perform: {
            for leader in data.c.leaders {
                if(leader.skills[skillPeriod] != targetSkill){
                    leaderIDs[leader.fName.lowercased()+" "+leader.lName.lowercased()] = leader.id
                }
            }
        })
    }
    init(targetSkill: String, skillPeriod: Int) {
        self.targetSkill = targetSkill
        self.skillPeriod = skillPeriod
    }
}

struct AssignSkillLeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AssignSkillLeaderView(targetSkill: "Test", skillPeriod: 0)
            .environmentObject(CampData())
    }
}
