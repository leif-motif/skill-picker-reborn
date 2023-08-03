//
//  ImportSkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-08-02.
//

import SwiftUI

struct ImportSkillView: View {
    @State private var selectedSkill: String = "this is an empty selection"
    //I love you, ChatGPT.
    @State private var skillMaximums: [String:[Float]] = importSkillList.reduce(into: [String:[Float]]()){ (result, element) in
        let (key, value) = element
        if(!value){
            //Ideally, these should all be 1.0, but since I can't get the Sliders to work, they're all at max.
            //Screw you, Swift compiler.
            result[key] = [20.0, 20.0, 20.0, 20.0]
        }
    }
    @State private var fanaticPeriods: [String:[Bool]] = importSkillList.reduce(into: [String:[Bool]]()){ (result, element) in
        let (key, value) = element
        if(value){
            result[key] = [false, false, false, false]
        }
    }
    private let range = 1.0...20.0
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Skill:", selection: $selectedSkill){
                ForEach(Array(importSkillList.keys), id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding()
            if(selectedSkill == "this is an empty selection"){
                //NOTHING!
            } else if(!importSkillList[selectedSkill]!){
                Group {
                    Text("To make a skill not run during a skill period, set the size to 0.")
                        .bold()
                        .padding(.trailing)
                    /*Slider(value: Binding($skillMaximums[selectedSkill])![0], in: range, step: 1){
                        Text("First Skill Size:")
                    }
                    .padding(.horizontal)*/
                    Text("\(Int(skillMaximums[selectedSkill]![0]))")
                        .bold()
                    /*Slider(value: Binding($skillMaximums[selectedSkill])![1], in: range, step: 1){
                        Text("Second Skill Size:")
                    }
                    .padding(.horizontal)*/
                    Text("\(Int(skillMaximums[selectedSkill]![1]))")
                        .bold()
                    /*Slider(value: Binding($skillMaximums[selectedSkill])![2], in: range, step: 1){
                        Text("Third Skill Size:")
                    }
                    .padding(.horizontal)*/
                    Text("\(Int(skillMaximums[selectedSkill]![2]))")
                        .bold()
                    /*Slider(value: Binding($skillMaximums[selectedSkill])![3], in: range, step: 1){
                        Text("Fourth Skill Size:")
                    }
                    .padding(.horizontal)*/
                    Text("\(Int(skillMaximums[selectedSkill]![3]))")
                        .bold()
                }
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
            HStack {
                Button("Cancel Import") {
                    dismiss()
                }
                Button("Import Skills") {
                    for skill in Array(importSkillList.keys) {
                        if(importSkillList[skill]!){
                            createFanatic(newFanatic: try! Fanatic(name: skill, activePeriods: fanaticPeriods[skill]!))
                        } else {
                            createSkill(newSkill: try! Skill(name: skill, maximums: skillMaximums[skill]!.map{Int($0)}))
                        }
                    }
                    dismiss()
                }
            }
            .padding([.bottom,.trailing])
        }
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
