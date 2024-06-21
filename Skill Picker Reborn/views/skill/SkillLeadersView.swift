/*
 * SkillLeadersView.swift
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

struct SkillLeadersView: View {
    @EnvironmentObject private var data: CampData
    @State private var selectedLeader = Set<Leader.ID>()
    @State private var leaderEditPass: HumanSelection<Leader>?
    @State private var leaderDestPass: HumanSelection<Leader>?
    @State private var assignSkillLeaderSheet = false
    @State private var removeLeaderConfirm = false
    @State private var deleteLeaderConfirm = false
    var body: some View {
        Text("Leaders")
            .font(.title)
            .bold()
            .padding(.top, 10)
        Table(data.c.skills[data.selectedSkill]!.leaders[data.selectedPeriod], selection: $selectedLeader, sortOrder: $data.skillLeaderSortOrder){
            TableColumn("First Name",value: \.fName)
            TableColumn("Last Name",value: \.lName)
            TableColumn("Cabin",value: \.cabin)
        }
        .frame(height: 85)
        .onChange(of: data.skillLeaderSortOrder){
            data.objectWillChange.send()
            data.c.skills[data.selectedSkill]!.leaders[data.selectedPeriod].sort(using: $0)
        }
        .contextMenu(forSelectionType: Leader.ID.self) { items in
            let leaderSelectionUnion = selectedLeader.union(items)
            if(leaderSelectionUnion.isEmpty){
                Button {
                    assignSkillLeaderSheet.toggle()
                } label: {
                    Label("Assign Leader to Skill...", systemImage: "plus")
                }
                .disabled(data.c.leaders.count == data.c.skills[data.selectedSkill]!.leaders[data.selectedPeriod].count)
            } else if(leaderSelectionUnion.count == 1){
                Button {
                    leaderEditPass = HumanSelection(selection: leaderSelectionUnion)
                } label: {
                    Label("Info/Edit...", systemImage: "pencil.line")
                }
            }
            if(leaderSelectionUnion.count > 0){
                Button(role: .destructive) {
                    leaderDestPass = HumanSelection(selection: leaderSelectionUnion)
                    removeLeaderConfirm.toggle()
                } label: {
                    if(leaderSelectionUnion.count == 1){
                        Label("Remove", systemImage: "trash")
                    } else {
                        Label("Remove Selection", systemImage: "trash")
                    }
                }
                .disabled(data.selectedSkill == "None")
                Button(role: .destructive) {
                    leaderDestPass = HumanSelection(selection: leaderSelectionUnion)
                    deleteLeaderConfirm.toggle()
                } label: {
                    if(leaderSelectionUnion.count == 1){
                        Label("Delete", systemImage: "trash")
                    } else {
                        Label("Delete Selection", systemImage: "trash")
                    }
                }
            }
        }
        //for some reason, empty selections no longer work, so a second contextMenu must be added.
        //trillion dollar company right here, folks. trillion dollar company.
        .contextMenu(){
            Button {
                assignSkillLeaderSheet.toggle()
            } label: {
                Label("Assign Leader to Skill...", systemImage: "plus")
            }
            .disabled(data.c.leaders.count == data.c.skills[data.selectedSkill]!.leaders[data.selectedPeriod].count)
        }
        .sheet(isPresented: $assignSkillLeaderSheet, onDismiss: {
            data.objectWillChange.send()
        }, content: {
            AssignSkillLeaderView(targetSkill: data.selectedSkill, skillPeriod: data.selectedPeriod)
        })
        .sheet(item: $leaderEditPass, onDismiss: {
            data.objectWillChange.send()
            selectedLeader = []
        }, content: { x in
            LeaderInfoView(leaderID: x.selection.first!)
        })
        .confirmationDialog("Confirm Removal", isPresented: $removeLeaderConfirm, presenting: leaderDestPass){ p in
            Button(role: .cancel){
            } label: {
                Text("Cancel")
            }
            Button(role: .destructive){
                if(data.c.fanatics.keys.contains(data.selectedSkill)){
                    #warning("possible group undo management needed")
                    for leaderID in p.selection {
                        try! removeLeaderFromFanatic(leaderID: leaderID, fanaticName: data.selectedSkill, data: data)
                    }
                } else {
                    for leaderID in p.selection {
                        try! removeLeaderFromSkill(leaderID: leaderID, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
                    }
                }
                leaderDestPass = nil
                selectedLeader = []
                data.objectWillChange.send()
            } label: {
                Text("Remove")
            }
        } message: { p in
            if(p.selection.count == 1){
                Text("Are you sure you want to remove the selected leader from the \(data.c.fanatics.keys.contains(data.selectedSkill) ? "fanatic" : "skill")?")
            } else {
                Text("Are you sure you want to remove multiple leaders from the \(data.c.fanatics.keys.contains(data.selectedSkill) ? "fanatic" : "skill")?")
            }
        }
        .confirmationDialog("Confirm Deletion", isPresented: $deleteLeaderConfirm, presenting: leaderDestPass){ p in
            Button(role: .cancel){
            } label: {
                Text("Cancel")
            }
            Button(role: .destructive){
                data.objectWillChange.send()
                for leaderID in p.selection {
                    deleteLeader(leaderID: leaderID, data: data, usingInternally: true)
                }
                leaderDestPass = nil
                selectedLeader = []
                #warning("TODO: handle group undo")
            } label: {
                Text("Remove")
            }
        } message: { p in
            if(p.selection.count == 1){
                Text("Are you sure you want to delete the selected leader?")
            } else {
                Text("Are you sure you want to delete "+String(p.selection.count)+" leaders?")
            }
        }
    }
}

#Preview {
    SkillLeadersView()
}
