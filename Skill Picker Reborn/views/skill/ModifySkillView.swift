/*
 * ModifySkillView.swift
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

struct ModifySkillView: View {
    @EnvironmentObject private var data: CampData
    @State private var iName = ""
    @State private var maximums = [1, 1, 1 ,1]
    private let range = 0...255
    private var targetSkill: String
    private var editing = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                TextField("Skill Name:", text: $iName)
            }
            Text("To make a skill not run during a skill period, set the size to 0.")
                .bold()
                .frame(width: 150, alignment: .center)
            VStack(alignment: .leading) {
                HStack {
                    TextField("First Skill Size:", value: $maximums[0], formatter: NumberFormatter())
                        .frame(width: 130)
                    Stepper(value: $maximums[0], in: range, step: 1) {
                        EmptyView()
                    }
                    .labelsHidden()
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    TextField("Second Skill Size:", value: $maximums[1], formatter: NumberFormatter())
                        .frame(width: 149)
                    Stepper(value: $maximums[1], in: range, step: 1) {
                        EmptyView()
                    }
                    .labelsHidden()
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    TextField("Third Skill Size:", value: $maximums[2], formatter: NumberFormatter())
                        .frame(width: 135)
                    Stepper(value: $maximums[2], in: range, step: 1) {
                        EmptyView()
                    }
                    .labelsHidden()
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    TextField("Fourth Skill Size:", value: $maximums[3], formatter: NumberFormatter())
                        .frame(width: 143)
                    Stepper(value: $maximums[3], in: range, step: 1) {
                        EmptyView()
                    }
                    .labelsHidden()
                }
            }
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                if(editing){
                    Button("Save Changes"){
                        try! data.modifySkill(oldName: targetSkill, newName: iName, newMaximums: maximums)
                        if(iName != targetSkill){
                            data.selectedSkill = iName
                        }
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(iName == "" || (data.c.skills.keys.contains(iName) && iName != targetSkill) || maximums == [0,0,0,0])
                } else {
                    Button("Add Skill") {
                        //There's probably a better way to do this but I no longer care.
                        for i in 0...3 {
                            if(maximums[i] < 0){
                                maximums[i] = 0
                            } else if(maximums[i] > 255){
                                maximums[i] = 255
                            }
                        }
                        data.createSkill(newSkill: try! Skill(name: iName, maximums: maximums))
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(iName == "" || data.c.skills.keys.contains(iName) || maximums == [0,0,0,0])
                }
            }
            .padding(.top)
        }
        .padding()
        .frame(width: editing ? 330 : 300, height: 270)
        .onAppear(perform: {
            iName = targetSkill
            if(editing){
                maximums = data.c.skills[targetSkill]!.maximums
            }
        })
    }
    init(targetSkill: String = "") throws {
        if(targetSkill == "None"){
            throw SPRError.NoneSkillRefusal
        }
        self.targetSkill = targetSkill
        self.editing = targetSkill != ""
    }
}

struct ModifySkillView_Previews: PreviewProvider {
    static var previews: some View {
        try! ModifySkillView()
            .environmentObject(CampData())
    }
}
