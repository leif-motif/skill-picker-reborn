/*
 * ImportSkillView.swift
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

struct ImportSkillView: View {
    private var data: CampData
    @State private var selectedSkill: String = "this is an empty selection"
    @State private var skillMaximums: [String:[Int]] = [:]
    @State private var fanaticPeriods: [String:[Bool]] = [:]
    private let range = 0...255
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            VStack(alignment: .leading){
                Picker("Skill:", selection: $selectedSkill){
                    ForEach(Array(data.importSkillList.keys).sorted(), id: \.self){
                        Text($0).tag($0)
                    }
                }
            }
            if(selectedSkill == "this is an empty selection"){
            } else if(!data.importSkillList[selectedSkill]!){
                //The only reason I am not displaying the number "0" outright is because the values in the TextFields won't update unless their unbinded value is shown somewhere.
                //I HATE THE SWIFT COMPILER I HATE THE SWIFT COMPILER I HATE THE SWIFT COMPILER
                Text("To make a skill not run during a skill period, set the size to "+String((skillMaximums[selectedSkill]![0]-skillMaximums[selectedSkill]![0]))+".")
                    .bold()
                    .frame(width: 150, alignment: .center)
                VStack(alignment: .leading) {
                    HStack {
                        TextField("First Skill Size:", value: Binding($skillMaximums[selectedSkill])![0], formatter: NumberFormatter())
                            .frame(width: 130)
                        Stepper(value: Binding($skillMaximums[selectedSkill])![0], in: range, step: 1) {
                            EmptyView()
                        }
                        .labelsHidden()
                        Text(try! AttributedString(markdown: "Total periods (capacity): **\(skillMaximums.values.map { $0[0] }.filter { $0 != 0 }.count) (\(skillMaximums.values.map { $0[0] }.reduce(0, +)))**"))
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Second Skill Size:", value: Binding($skillMaximums[selectedSkill])![1], formatter: NumberFormatter())
                            .frame(width: 149)
                        Stepper(value: Binding($skillMaximums[selectedSkill])![1], in: range, step: 1) {
                            EmptyView()
                        }
                        .labelsHidden()
                        Text(try! AttributedString(markdown: "Total periods (capacity): **\(skillMaximums.values.map { $0[1] }.reduce(0, +) ) (\(skillMaximums.values.map { $0[1] }.filter { $0 != 0 }.count))**"))
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Third Skill Size:", value: Binding($skillMaximums[selectedSkill])![2], formatter: NumberFormatter())
                            .frame(width: 135)
                        Stepper(value: Binding($skillMaximums[selectedSkill])![2], in: range, step: 1) {
                            EmptyView()
                        }
                        .labelsHidden()
                        Text(try! AttributedString(markdown:"Total periods (capacity): **\(skillMaximums.values.map { $0[2] }.reduce(0, +) ) (\(skillMaximums.values.map { $0[2] }.filter { $0 != 0 }.count))**"))
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Fourth Skill Size:", value: Binding($skillMaximums[selectedSkill])![3], formatter: NumberFormatter())
                            .frame(width: 143)
                        Stepper(value: Binding($skillMaximums[selectedSkill])![3], in: range, step: 1) {
                            EmptyView()
                        }
                        .labelsHidden()
                        Text(try! AttributedString(markdown: "Total periods (capacity): **\(skillMaximums.values.map { $0[3] }.reduce(0, +) ) (\(skillMaximums.values.map { $0[3] }.filter { $0 != 0 }.count))**"))
                    }
                }
            } else if(data.importSkillList[selectedSkill]!){
                //fanatic
                Toggle(isOn: Binding($fanaticPeriods[selectedSkill])![0]){
                    Text("First Skill:")
                }
                .toggleStyle(.switch)
                Toggle(isOn: Binding($fanaticPeriods[selectedSkill])![1]){
                    Text("Second Skill:")
                }
                .toggleStyle(.switch)
                Toggle(isOn: Binding($fanaticPeriods[selectedSkill])![2]){
                    Text("Third Skill:")
                }
                .toggleStyle(.switch)
                Toggle(isOn: Binding($fanaticPeriods[selectedSkill])![3]){
                    Text("Fourth Skill:")
                }
                .toggleStyle(.switch)
            }
            Spacer()
            HStack {
                Spacer()
                Button("Cancel Import") {
                    dismiss()
                }
                Button("Import Skills") {
                    for skill in Array(data.importSkillList.keys) {
                        if(data.importSkillList[skill]!){
                            createFanatic(newFanatic: try! Fanatic(name: skill, activePeriods: fanaticPeriods[skill]!), data: data, usingInternally: true)
                        } else {
                            for i in 0...3 {
                                if(skillMaximums[skill]![i] < 0){
                                    skillMaximums[skill]![i] = 0
                                } else if(skillMaximums[skill]![i] > 255){
                                    skillMaximums[skill]![i] = 255
                                }
                            }
                            createSkill(newSkill: try! Skill(name: skill, maximums: skillMaximums[skill]!), data: data, usingInternally: true)
                        }
                    }
                    data.isImporting = true
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(skillMaximums.values.contains([0,0,0,0]) || fanaticPeriods.values.contains([false,false,false,false]))
            }
        }
        .padding()
        .frame(width: 400, height: 260)
        .onAppear(perform: {
            //I love you, ChatGPT.
            skillMaximums = data.importSkillList.reduce(into: [String:[Int]]()){ (result, element) in
                let (key, value) = element
                if(!value){
                    result[key] = [0, 0, 0, 0]
                }
            }
            fanaticPeriods = data.importSkillList.reduce(into: [String:[Bool]]()){ (result, element) in
                let (key, value) = element
                if(value){
                    result[key] = [false, false, false, false]
                }
            }
        })
    }
    init(data: CampData) throws {
        self.data = data
        if(data.importSkillList == [:]){
            throw SPRError.EmptySelection
        }
    }
}

/*struct ImportSkillView_Previews: PreviewProvider {
    static var previews: some View {
        try! ImportSkillView()
    }
}*/
