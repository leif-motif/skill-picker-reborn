/*
 * CamperInfoView.swift
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

struct CamperInfoView: View {
    @EnvironmentObject private var data: CampData
    @State private var targetCamper: Camper = try! Camper(fName: "", lName: "", cabin: "", preferredSkills: ["None","None","None","None","None","None"], fanatic: "None")
    @State private var newFirstName = ""
    @State private var newLastName = ""
    @State private var newCabin = ""
    @State private var newFanatic = ""
    @State private var newPreferredSkills = ["None","None","None","None","None","None"]
    @State private var duplicateSkillsAlert = false
    private var camperSelection: Set<Camper.ID>
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
            Picker("Fanatic:", selection: $newFanatic){
                Text("None").tag("None")
                ForEach(Array(data.fanatics.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding(.bottom)
            Text("Skills:")
                .bold()
                .padding(.bottom, 1)
            Group {
                LabeledContent {
                    Text(targetCamper.skills[0])
                } label: {
                    Text("Skill One:")
                        .bold()
                }
                .padding(.bottom, 2)
                LabeledContent {
                    Text(targetCamper.skills[1])
                } label: {
                    Text("Skill Two:")
                        .bold()
                }
                .padding(.bottom, 2)
                LabeledContent {
                    Text(targetCamper.skills[2])
                } label: {
                    Text("Skill Three:")
                        .bold()
                }
                .padding(.bottom, 2)
                LabeledContent {
                    Text(targetCamper.skills[3])
                } label: {
                    Text("Skill Four:")
                        .bold()
                }
            }
            Text("Preferred Skills:")
                .bold()
                .padding(.top, 8)
            Group {
                Picker("First:", selection: $newPreferredSkills[0]){
                    ForEach(Array(data.skills.keys).sorted().filter({!data.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Second:", selection: $newPreferredSkills[1]){
                    ForEach(Array(data.skills.keys).sorted().filter({!data.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Third:", selection: $newPreferredSkills[2]){
                    ForEach(Array(data.skills.keys).sorted().filter({!data.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Fourth:", selection: $newPreferredSkills[3]){
                    ForEach(Array(data.skills.keys).sorted().filter({!data.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Fifth:", selection: $newPreferredSkills[4]){
                    ForEach(Array(data.skills.keys).sorted().filter({!data.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Sixth:", selection: $newPreferredSkills[5]){
                    ForEach(Array(data.skills.keys).sorted().filter({!data.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                .disabled(newFanatic != "None")
            }
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
                .alert(isPresented: $duplicateSkillsAlert) {
                    Alert(title: Text("Error!"),
                          message: Text("Duplicate preferred skills found. All duplicates have been removed."),
                          dismissButton: .default(Text("Dismiss")))
                }
            }
            .padding(.top)
        }
        .padding()
        .frame(width: 300, height: 540)
        .onAppear(perform: {
            targetCamper = data.campers.first(where: {$0.id == camperSelection.first})!
            newFirstName = targetCamper.fName
            newLastName = targetCamper.lName
            newCabin = targetCamper.cabin
            newFanatic = targetCamper.fanatic
            newPreferredSkills = targetCamper.preferredSkills
            if(targetCamper.fanatic != "None"){
                newPreferredSkills.append("None")
            }
        })
    }
    init(camperSelection: Set<Camper.ID>) throws {
        if(camperSelection.count != 1){
            throw SPRError.EmptySelection
        }
        self.camperSelection = camperSelection
    }
}

/*
struct CamperInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CamperInfoView()
    }
}*/
