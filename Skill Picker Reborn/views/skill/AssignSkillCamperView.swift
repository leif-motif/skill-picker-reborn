/*
 * AssignSkillCamperView.swift
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

import SwiftUI

struct AssignSkillCamperView: View {
    @EnvironmentObject private var data: CampData
    private var targetSkill: String
    private var skillPeriod: Int
    @State private var camperInput = ""
    @State private var camperIDs: [String:Camper.ID] = [:]
    @State private var isFanatic: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            if(isFanatic){
                TextField("Camper:", text: $camperInput)
                Text("Warning: This will remove the\ncamper's sixth preferred skill.")
                    .bold()
                    .padding(.bottom)
            } else {
                //I HATE THE SWIFT COMPILER- this should NOT be done more than once but whatever
                TextField("Camper:", text: $camperInput)
                    .padding(.bottom)
            }
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Camper") {
                    if(isFanatic){
                        //quite frankly, i thought searching for specific campers wasn't working.
                        //and yet, when i last tested this, it is now. if anything is going wacko, it's because of this.
                        data.objectWillChange.send()
                        if(data.getCamper(camperID: camperIDs[camperInput.lowercased()]!)!.fanatic != "None"){
                            try! data.removeCamperFromFanatic(camperID: camperIDs[camperInput.lowercased()]!,
                                                         fanaticName: data.getCamper(camperID: camperIDs[camperInput.lowercased()]!)!.fanatic,
                                                         newSixthPreferredSkill: "THIS SKILL SHOULDN'T EXIST", usingInternally: true)
                        }
                        try! data.assignCamperToFanatic(targetCamper: data.getCamper(camperID: camperIDs[camperInput.lowercased()]!)!, fanaticName: targetSkill, usingInternally: true)
                        #warning("TODO: handle group undo")
                    } else {
                        data.assignCamperToSkill(targetCamper: data.getCamper(camperID: camperIDs[camperInput.lowercased()]!)!, skillName: targetSkill, period: skillPeriod)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(!camperIDs.keys.contains(camperInput.lowercased()))
            }
        }
        .padding()
        .frame(width: 280, height: isFanatic ? 130 : 100)
        .onAppear(perform: {
            isFanatic = data.c.fanatics.keys.contains(targetSkill)
            if(isFanatic){
                for camper in data.c.campers {
                    if(!camper.skills.contains(targetSkill) && !camper.skills.contains { key in
                        data.c.fanatics.keys.contains(key)
                    }){
                        camperIDs[camper.fName.lowercased()+" "+camper.lName.lowercased()] = camper.id
                    }
                }
            } else {
                for camper in data.c.campers {
                    if(camper.skills[skillPeriod] != targetSkill && !data.c.fanatics.keys.contains(camper.skills[skillPeriod])){
                        camperIDs[camper.fName.lowercased()+" "+camper.lName.lowercased()] = camper.id
                    }
                }
            }
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
