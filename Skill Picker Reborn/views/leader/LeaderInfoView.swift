/*
 * LeaderInfoView.swift
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

struct LeaderInfoView: View {
    @EnvironmentObject private var data: CampData
    @State private var targetLeader = try! Leader(fName: "", lName: "", senior: true)
    @State private var newFirstName = ""
    @State private var newLastName = ""
    @State private var newCabin = ""
    @State private var newSkills = ["None","None","None","None"]
    @State private var newSenior = false
    private var leaderSelection: Set<Leader.ID>
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("First Name:",text: $newFirstName)
            TextField("Last Name:",text: $newLastName)
            Picker("Cabin:", selection: $newCabin) {
                ForEach(Array(data.cabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            Toggle(isOn: $newSenior){
                Text("Senior:")
            }
            .toggleStyle(.switch)
            .padding(.bottom)
            Text("Skills:")
                .bold()
            Picker("Skill 1:", selection: $newSkills[0]){
                ForEach(Array(data.skills.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .disabled(data.fanatics.keys.contains(newSkills[0]))
            Picker("Skill 2:", selection: $newSkills[1]){
                ForEach(Array(data.skills.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .disabled(data.fanatics.keys.contains(newSkills[1]))
            Picker("Skill 3:", selection: $newSkills[2]){
                ForEach(Array(data.skills.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .disabled(data.fanatics.keys.contains(newSkills[2]))
            Picker("Skill 4:", selection: $newSkills[3]){
                ForEach(Array(data.skills.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .disabled(data.fanatics.keys.contains(newSkills[3]))
            HStack {
                Spacer()
                Button("Dismiss") {
                    dismiss()
                }
                Button("Save Changes") {
                    dismiss()
                }
                .disabled(newFirstName == "" || newLastName == "")
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding(.top)
        }
        .padding()
        .frame(width: 300, height: 340)
        .onAppear(perform: {
            targetLeader = data.leaders.first(where: {$0.id == leaderSelection.first})!
            newFirstName = targetLeader.fName
            newLastName = targetLeader.lName
            newCabin = targetLeader.cabin
            newSkills = targetLeader.skills
            newSenior = targetLeader.senior
        })
    }
    init(leaderSelection: Set<Leader.ID>) throws {
        if(leaderSelection.count != 1){
            throw SPRError.EmptySelection
        }
        self.leaderSelection = leaderSelection
    }
}

/*
struct LeaderInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderInfoView()
            .environmentObject(CampData())
    }
}*/
