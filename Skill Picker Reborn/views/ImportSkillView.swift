//
//  ImportSkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-08-02.
//

import SwiftUI

struct ImportSkillView: View {
    @EnvironmentObject private var data: CampData
    @State private var selectedSkill: String = "this is an empty selection"
    //I love you, ChatGPT.
    @State private var skillMaximums: [String:[Int]] = importSkillList.reduce(into: [String:[Int]]()){ (result, element) in
        let (key, value) = element
        if(!value){
            result[key] = [1, 1, 1, 1]
        }
    }
    @State private var fanaticPeriods: [String:[Bool]] = importSkillList.reduce(into: [String:[Bool]]()){ (result, element) in
        let (key, value) = element
        if(value){
            result[key] = [false, false, false, false]
        }
    }
    private let range = 0...20
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            VStack(alignment: .leading){
                Picker("Skill:", selection: $selectedSkill){
                    ForEach(Array(importSkillList.keys), id: \.self){
                        Text($0).tag($0)
                    }
                }
            }
            .padding([.top,.horizontal])
            if(selectedSkill == "this is an empty selection"){
            } else if(!importSkillList[selectedSkill]!){
                //The only reason I am not displaying the number "0" outright is because the values in the TextFields won't update unless their unbinded value is shown somewhere.
                //I HATE THE SWIFT COMPILER I HATE THE SWIFT COMPILER I HATE THE SWIFT COMPILER
                Text("To make a skill not run during a skill period, set the size to "+String((skillMaximums[selectedSkill]![0]/skillMaximums[selectedSkill]![0])-1)+".")
                    .bold()
                    .frame(width: 150, alignment: .center)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    HStack {
                        TextField("First Skill Size:", value: Binding($skillMaximums[selectedSkill])![0], formatter: NumberFormatter())
                            .frame(width: 130)
                        Stepper(value: Binding($skillMaximums[selectedSkill])![0], in: range, step: 1) {
                            EmptyView()
                        }
                        .labelsHidden()
                    }
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Second Skill Size:", value: Binding($skillMaximums[selectedSkill])![1], formatter: NumberFormatter())
                            .frame(width: 149)
                        Stepper(value: Binding($skillMaximums[selectedSkill])![1], in: range, step: 1) {
                            EmptyView()
                        }
                        .labelsHidden()
                    }
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Third Skill Size:", value: Binding($skillMaximums[selectedSkill])![2], formatter: NumberFormatter())
                            .frame(width: 135)
                        Stepper(value: Binding($skillMaximums[selectedSkill])![2], in: range, step: 1) {
                            EmptyView()
                        }
                        .labelsHidden()
                    }
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Fourth Skill Size:", value: Binding($skillMaximums[selectedSkill])![3], formatter: NumberFormatter())
                            .frame(width: 143)
                        Stepper(value: Binding($skillMaximums[selectedSkill])![3], in: range, step: 1) {
                            EmptyView()
                        }
                        .labelsHidden()
                    }
                }
                .padding(.horizontal)
            } else if(importSkillList[selectedSkill]!){
                //fanatic
                Toggle(isOn: Binding($fanaticPeriods[selectedSkill])![0]){
                    Text("First Skill:")
                }
                .padding(.horizontal)
                .toggleStyle(.switch)
                Toggle(isOn: Binding($fanaticPeriods[selectedSkill])![1]){
                    Text("Second Skill:")
                }
                .padding(.horizontal)
                .toggleStyle(.switch)
                Toggle(isOn: Binding($fanaticPeriods[selectedSkill])![2]){
                    Text("Third Skill:")
                }
                .padding(.horizontal)
                .toggleStyle(.switch)
                Toggle(isOn: Binding($fanaticPeriods[selectedSkill])![3]){
                    Text("Fourth Skill:")
                }
                .toggleStyle(.switch)
                .padding([.bottom,.horizontal])
            }
            Spacer()
            HStack {
                Spacer()
                Button("Cancel Import") {
                    dismiss()
                }
                Button("Import Skills") {
                    for skill in Array(importSkillList.keys) {
                        if(importSkillList[skill]!){
                            createFanatic(newFanatic: try! Fanatic(name: skill, activePeriods: fanaticPeriods[skill]!), data: data)
                        } else {
                            for i in 0...3 {
                                if(skillMaximums[skill]![i] < 0){
                                    skillMaximums[skill]![i] = 0
                                } else if(skillMaximums[skill]![i] > 20){
                                    skillMaximums[skill]![i] = 20
                                }
                            }
                            createSkill(newSkill: try! Skill(name: skill, maximums: skillMaximums[skill]!), data: data)
                        }
                    }
                    isImporting = true
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding([.bottom,.trailing])
        }
        .frame(width: 360, height: 255)
    }
    init() throws {
        if(importSkillList == [:]){
            throw SPRError.EmptySelection
        }
    }
}

struct ImportSkillView_Previews: PreviewProvider {
    static var previews: some View {
        try! ImportSkillView()
    }
}
