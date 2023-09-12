/*
 * AssignSkillCamperView.swift
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

struct AssignSkillCamperView: View {
    @EnvironmentObject private var data: CampData
    private var targetSkill: String
    private var skillPeriod: Int
    @State private var selectedCamper = UUID()
    @State private var isFanatic: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            if(isFanatic){
                Picker("Camper:", selection: $selectedCamper){
                    ForEach(0...(data.campers.count-1), id: \.self){
                        if(data.campers[$0].fanatic != targetSkill){
                            Text(data.campers[$0].fName+" "+data.campers[$0].lName).tag(data.campers[$0].id)
                        }
                    }
                }
                Text("Warning: This will remove the\ncamper's sixth preferred skill.")
                    .bold()
            } else {
                Picker("Camper:", selection: $selectedCamper){
                    ForEach(0...(data.campers.count-1), id: \.self){
                        if(data.campers[$0].skills[skillPeriod] != targetSkill && !data.fanatics.keys.contains(data.campers[$0].skills[skillPeriod])){
                            Text(data.campers[$0].fName+" "+data.campers[$0].lName).tag(data.campers[$0].id)
                        }
                    }
                }
                .padding(.bottom)
            }
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Camper") {
                    if(isFanatic){
                        if(data.campers.first(where: {$0.id == selectedCamper})!.fanatic != "None"){
                            try! removeCamperFromFanatic(camperSelection: [selectedCamper],
                                                         fanaticName: data.campers.first(where: {$0.id == selectedCamper})!.fanatic,
                                                         newSixthPreferredSkill: "THIS SKILL SHOULDN'T EXIST", data: data)
                        }
                        try! assignCamperToFanatic(targetCamper: data.campers.first(where: {$0.id == selectedCamper})!,
                                                   fanaticName: targetSkill,
                                                   data: data)
                    } else {
                        assignCamperToSkill(targetCamper: data.campers.first(where: {$0.id == selectedCamper})!,
                                            skillName: targetSkill, period: skillPeriod,
                                            data: data)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(data.campers.first(where: {$0.id == selectedCamper}) == nil)
            }
        }
        .padding()
        .frame(width: 280, height: isFanatic ? 130 : 100)
        .onAppear(perform: {
            isFanatic = data.fanatics.keys.contains(targetSkill)
        })
    }
    init(targetSkill: String, skillPeriod: Int) {
        self.targetSkill = targetSkill
        self.skillPeriod = skillPeriod
    }
}

/*this keeps crashing?
struct AssignSkillCamperView_Previews: PreviewProvider {
    static var previews: some View {
        AssignSkillCamperView(targetSkill: "Test", skillPeriod: 0)
            .environmentObject(CampData())
    }
}*/
