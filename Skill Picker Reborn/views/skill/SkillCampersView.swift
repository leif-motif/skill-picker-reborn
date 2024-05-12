/*
 * SkillCampersView.swift
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

struct SkillCampersView: View {
    @EnvironmentObject private var data: CampData
    @State private var selectedCamper = Set<Camper.ID>()
    @State private var camperEditPass: HumanSelection<Camper>?
    @State private var camperDestPass: HumanSelection<Camper>?
    @State private var assignSkillCamperSheet = false
    @State private var removeCamperConfirm = false
    @State private var deleteCamperConfirm = false
    var body: some View {
        @State var currentSkillCount = data.skills[data.selectedSkill]!.periods[data.selectedPeriod].count
        @State var currentSkillMax = data.skills[data.selectedSkill]!.maximums[data.selectedPeriod]
        Text("Campers ("+String(currentSkillCount)+"/"+String(currentSkillMax)+")")
            .font(.title)
            .bold()
            .foregroundColor(currentSkillCount > currentSkillMax ? Color(.systemRed) : Color.primary)
        Table(data.skills[data.selectedSkill]!.periods[data.selectedPeriod], selection: $selectedCamper, sortOrder: $data.skillCamperSortOrder){
            TableColumn("First Name",value: \.fName)
            TableColumn("Last Name",value: \.lName)
            TableColumn("Cabin",value: \.cabin)
        }
        .onChange(of: data.skillCamperSortOrder){
            data.objectWillChange.send()
            data.skills[data.selectedSkill]!.periods[data.selectedPeriod].sort(using: $0)
        }
        .contextMenu(forSelectionType: Camper.ID.self) { items in
            let camperSelectionUnion = selectedCamper.union(items)
            if(camperSelectionUnion.isEmpty){
                Button {
                    assignSkillCamperSheet.toggle()
                } label: {
                    Label("Assign Camper to Skill...", systemImage: "plus")
                }
            } else if(camperSelectionUnion.count == 1){
                Button {
                    camperEditPass = HumanSelection(selection: camperSelectionUnion)
                } label: {
                    Label("Info/Edit...", systemImage: "pencil.line")
                }
            }
            if(camperSelectionUnion.count > 0){
                Button(role: .destructive) {
                    camperDestPass = HumanSelection(selection: camperSelectionUnion)
                    removeCamperConfirm.toggle()
                } label: {
                    if(camperSelectionUnion.count == 1){
                        Label("Remove", systemImage: "trash")
                    } else {
                        Label("Remove Selection", systemImage: "trash")
                    }
                }
                .disabled(data.selectedSkill == "None")
                Button(role: .destructive) {
                    camperDestPass = HumanSelection(selection: camperSelectionUnion)
                    deleteCamperConfirm.toggle()
                } label: {
                    if(camperSelectionUnion.count == 1){
                        Label("Delete", systemImage: "trash")
                    } else {
                        Label("Delete Selection", systemImage: "trash")
                    }
                }
            }
        }
        .contextMenu(){
            Button {
                assignSkillCamperSheet.toggle()
            } label: {
                Label("Assign Camper to Skill...", systemImage: "plus")
            }
        }
        .sheet(item: $camperEditPass, onDismiss: {
            data.objectWillChange.send()
            selectedCamper = []
        }, content: { x in
            CamperInfoView(camperID: x.selection.first!)
        })
        .sheet(isPresented: $assignSkillCamperSheet, onDismiss: {
            data.objectWillChange.send()
        }, content: {
            AssignSkillCamperView(targetSkill: data.selectedSkill, skillPeriod: data.selectedPeriod)
        })
        .confirmationDialog("Confirm Removal", isPresented: $removeCamperConfirm, presenting: camperDestPass){ p in
            Button(role: .cancel){
            } label: {
                Text("Cancel")
            }
            Button(role: .destructive){
                //remove from skill
                if(data.fanatics.keys.contains(data.selectedSkill)){
                    for camperID in p.selection {
                        try! removeCamperFromFanatic(camperID: camperID, fanaticName: data.selectedSkill, newSixthPreferredSkill: "None", data: data)
                    }
                } else {
                    for camperID in p.selection {
                        try! removeCamperFromSkill(camperID: camperID, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
                    }
                }
                camperDestPass = nil
                selectedCamper = []
                data.objectWillChange.send()
            } label: {
                Text("Remove")
            }
        } message: { p in
            if(p.selection.count == 1){
                Text("Are you sure you want to remove the selected camper from the \(data.fanatics.keys.contains(data.selectedSkill) ? "fanatic" : "skill")?")
            } else {
                Text("Are you sure you want to remove multiple campers from the \(data.fanatics.keys.contains(data.selectedSkill) ? "fanatic" : "skill")?")
            }
        }
        .confirmationDialog("Confirm Deletion", isPresented: $deleteCamperConfirm, presenting: camperDestPass){ p in
            Button(role: .cancel){
            } label: {
                Text("Cancel")
            }
            Button(role: .destructive){
                for camperID in p.selection {
                    deleteCamper(camperID: camperID, data: data)
                }
                camperDestPass = nil
                selectedCamper = []
            } label: {
                Text("Remove")
            }
        } message: { p in
            if(p.selection.count == 1){
                Text("Are you sure you want to delete the selected camper?")
            } else {
                Text("Are you sure you want to delete "+String(p.selection.count)+" campers?")
            }
        }
    }
    
    init(){
        
    }
}

#Preview {
    SkillCampersView()
}
