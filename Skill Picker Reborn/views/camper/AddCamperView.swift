/*
 * AddCamperView.swift
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

struct AddCamperView: View {
    @EnvironmentObject private var data: CampData
    @State private var iFName = ""
    @State private var iLName = ""
    @State private var selectedCabin = "Unassigned"
    @State private var preferredSkills = ["None","None","None","None","None","None"]
    @State private var fanaticSelection = "None"
    @State private var duplicateSkillsAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("First Name:",text: $iFName)
            TextField("Last Name:",text: $iLName)
            Picker("Cabin:", selection: $selectedCabin) {
                ForEach(Array(data.c.cabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            Picker("Fanatic:", selection: $fanaticSelection){
                Text("None").tag("None")
                ForEach(Array(data.c.fanatics.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding(.bottom)
            Text("Preferred Skills:")
                .bold()
            Group {
                #warning("TODO: change this to be a ForEach")
                Picker("First:", selection: $preferredSkills[0]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Second:", selection: $preferredSkills[1]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Third:", selection: $preferredSkills[2]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Fourth:", selection: $preferredSkills[3]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Fifth:", selection: $preferredSkills[4]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Sixth:", selection: $preferredSkills[5]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                .disabled(fanaticSelection != "None")
            }
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Camper"){
                    preferredSkills.removeAll(where: {$0 == "None"})
                    if(preferredSkills != preferredSkills.uniqued()){
                        preferredSkills = preferredSkills.uniqued()
                        while(preferredSkills.count < 6){
                            preferredSkills.append("None")
                        }
                        duplicateSkillsAlert.toggle()
                    } else {
                        if(fanaticSelection != "None" && preferredSkills.count == 6){
                            preferredSkills.remove(at: 5)
                        }
                        while(preferredSkills.count < (fanaticSelection == "None" ? 6 : 5)){
                            preferredSkills.append("None")
                        }
                        try! data.createCamper(newCamper: try! Camper(fName: iFName, lName: iLName, cabin: selectedCabin, preferredSkills: preferredSkills, fanatic: fanaticSelection))
                        dismiss()
                    }
                }
                .disabled(iFName == "" || iLName == "" || !humanIsUnique(fName: iFName, lName: iLName, humanSet: data.c.campers))
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
        .frame(width: 300, height: 370)
        .padding()
    }
}

struct AddCamperView_Previews: PreviewProvider {
    static var previews: some View {
        AddCamperView()
            .environmentObject(CampData())
    }
}
