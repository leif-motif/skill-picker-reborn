/*
 * ModifyFanaticView.swift
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

struct ModifyFanaticView: View {
    @EnvironmentObject private var data: CampData
    @State private var iName = ""
    @State private var activePeriods = [false,false,false,false]
    private var targetFanatic: String
    private var editing: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:", text: $iName)
                .padding(.bottom)
            Toggle(isOn: $activePeriods[0]){
                Text("First Skill:")
            }
            .toggleStyle(.switch)
            Toggle(isOn: $activePeriods[1]){
                Text("Second Skill:")
            }
            .toggleStyle(.switch)
            Toggle(isOn: $activePeriods[2]){
                Text("Third Skill:")
            }
            .toggleStyle(.switch)
            Toggle(isOn: $activePeriods[3]){
                Text("Fourth Skill:")
            }
            .toggleStyle(.switch)
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                if(editing){
                    Button("Save Changes"){
                        if(iName != targetFanatic){
                            try! renameFanatic(oldName: targetFanatic, newName: iName, data: data)
                            data.selectedSkill = iName
                        }
                        dismiss()
                    }
                    .disabled(iName == "" || (data.skills.keys.contains(iName) && iName != targetFanatic) || activePeriods == [false,false,false,false])
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                } else {
                    Button("Add Fanatic") {
                        createFanatic(newFanatic: try! Fanatic(name: iName, activePeriods: activePeriods), data: data)
                        dismiss()
                    }
                    .disabled(iName == "" || data.skills.keys.contains(iName) || activePeriods == [false,false,false,false])
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
            .padding(.top)
        }
        .padding()
        .frame(width: editing ? 300 : 280, height: 250)
        .onAppear(perform: {
            iName = targetFanatic
            if(editing){
                activePeriods = data.fanatics[targetFanatic]!.activePeriods
            }
        })
    }
    init(targetFanatic: String = ""){
        self.targetFanatic = targetFanatic
        self.editing = targetFanatic != ""
    }
}

struct ModifyFanaticView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyFanaticView()
            .environmentObject(CampData())
    }
}
