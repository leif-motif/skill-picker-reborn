/*
 * AssignSkillLeaderView.swift
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

struct AssignSkillLeaderView: View {
    @EnvironmentObject private var data: CampData
    @State private var isFanatic: Bool = false
    private let targetSkill: String
    private let skillPeriod: Int
    @State private var selectedLeader = UUID()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Leader:", selection: $selectedLeader){
                ForEach(0...(data.leaders.count-1), id: \.self){
                    if(isFanatic){
                        if(!data.leaders[$0].skills.contains(targetSkill) && !data.leaders[$0].skills.contains { key in
                            data.fanatics.keys.contains(key)
                        }){
                            Text(data.leaders[$0].fName+" "+data.leaders[$0].lName).tag(data.leaders[$0].id)
                        }
                    } else {
                        if(data.leaders[$0].skills[skillPeriod] != targetSkill && !data.fanatics.keys.contains(data.leaders[$0].skills[skillPeriod])){
                            Text(data.leaders[$0].fName+" "+data.leaders[$0].lName).tag(data.leaders[$0].id)
                        }
                    }
                }
            }
            .padding()
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Leader") {
                    if(isFanatic){
                        try! assignLeaderToFanatic(targetLeader: data.leaders.first(where: {$0.id == selectedLeader})!,
                                                   fanaticName: targetSkill,
                                                   data: data)
                    } else {
                        assignLeaderToSkill(targetLeader: data.leaders.first(where: {$0.id == selectedLeader})!,
                                            skillName: targetSkill, period: skillPeriod,
                                            data: data)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(data.leaders.first(where: {$0.id == selectedLeader}) == nil)
            }
            .padding([.bottom,.trailing])
        }
        .frame(width: 270, height: 90)
        .onAppear(perform: {
            isFanatic = data.fanatics.keys.contains(self.targetSkill)
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
    }
}
