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
        Table(data.skills[data.selectedSkill]!.leaders[data.selectedPeriod], selection: $selectedLeader, sortOrder: $data.skillLeaderSortOrder){
            TableColumn("First Name",value: \.fName)
            TableColumn("Last Name",value: \.lName)
            TableColumn("Cabin",value: \.cabin)
        }
        .frame(height: 85)
        .onChange(of: data.skillLeaderSortOrder){
            data.objectWillChange.send()
            data.skills[data.selectedSkill]!.leaders[data.selectedPeriod].sort(using: $0)
        }
        .contextMenu(forSelectionType: Leader.ID.self) { items in
            let leaderSelectionUnion = selectedLeader.union(items)
            if(leaderSelectionUnion.isEmpty){
                Button {
                    assignSkillLeaderSheet.toggle()
                } label: {
                    Label("Assign Leader to Skill...", systemImage: "plus")
                }
                .disabled(data.leaders.count == data.skills[data.selectedSkill]!.leaders[data.selectedPeriod].count)
            } else if(leaderSelectionUnion.count == 1){
                Button {
                    leaderEditPass = HumanSelection(selection: leaderSelectionUnion)
                } label: {
                    Label("Info/Edit...", systemImage: "pencil.line")
                }
            }
            if(leaderSelectionUnion.count > 0){
                Button(role: .destructive) {
                    #warning("TODO: enable deletion and removal of leaders")
                    /*if(data.fanatics.keys.contains(data.selectedSkill)){
                     for leaderID in selectedLeader.union(items){
                     try! removeLeaderFromFanatic(leaderID: leaderID, fanaticName: data.selectedSkill, data: data)
                     }
                     } else {
                     for leaderID in selectedLeader.union(items){
                     try! removeLeaderFromSkill(leaderID: leaderID, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
                     }
                     }
                     data.objectWillChange.send()*/
                } label: {
                    if(leaderSelectionUnion.count == 1){
                        Label("Remove", systemImage: "trash")
                    } else {
                        Label("Remove Selection", systemImage: "trash")
                    }
                }
                .disabled(data.selectedSkill == "None")
                Button(role: .destructive) {
                    /*for leaderID in selectedLeader.union(items) {
                     deleteLeader(leaderID: leaderID, data: data)
                     }
                     data.objectWillChange.send()*/
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
            .disabled(data.leaders.count == data.skills[data.selectedSkill]!.leaders[data.selectedPeriod].count)
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
    }
    init(){
        
    }
}

#Preview {
    SkillLeadersView()
}
