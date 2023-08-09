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
    @State private var noneCamperAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Camper:", selection: $selectedCamper){
                ForEach(0...(data.campers.count-1), id: \.self){
                    if(data.campers[$0].skills[skillPeriod] != targetSkill){
                        Text(data.campers[$0].fName+" "+data.campers[$0].lName).tag(data.campers[$0].id)
                    }
                }
            }
            .padding()
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Camper") {
                    let targetCamper: Camper? = data.campers.first(where: {$0.id == selectedCamper})
                    if(targetCamper != nil){
                        try! assignCamperToSkill(targetCamper: targetCamper!,
                                                 skillName: targetSkill, period: skillPeriod,
                                                 data: data)
                        dismiss()
                    } else {
                        noneCamperAlert.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding([.bottom,.trailing])
        }
        .frame(width: 280, height: 90)
        .alert(isPresented: $noneCamperAlert) {
            Alert(title: Text("Error!"),
                  message: Text("A camper to assign to the skill must be selected."),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
    init(targetSkill: String, skillPeriod: Int) {
        self.targetSkill = targetSkill
        self.skillPeriod = skillPeriod
    }
}

struct AssignSkillCamperView_Previews: PreviewProvider {
    static var previews: some View {
        AssignSkillCamperView(targetSkill: "Test", skillPeriod: 0)
    }
}
