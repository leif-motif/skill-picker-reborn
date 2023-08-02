//
//  AddSkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddSkillView: View {
    @State private var iName = ""
    @State private var maximums = [1.0, 1.0 ,1.0 ,1.0]
    private let range = 0.0...20.0
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:", text: $iName)
                .padding(.all)
            Group {
                Text("To make a skill not run during a skill period, set the size to 0.")
                    .bold()
                    .padding(.trailing)
                Slider(value: $maximums[0], in: range, step: 1){
                    Text("First Skill Size:")
                }
                .padding(.horizontal)
                Text("\(Int(maximums[0]))")
                    .bold()
                Slider(value: $maximums[1], in: range, step: 1){
                    Text("Second Skill Size:")
                }
                .padding(.horizontal)
                Text("\(Int(maximums[1]))")
                    .bold()
                Slider(value: $maximums[2], in: range, step: 1){
                    Text("Third Skill Size:")
                }
                .padding(.horizontal)
                Text("\(Int(maximums[2]))")
                    .bold()
                Slider(value: $maximums[3], in: range, step: 1){
                    Text("Fourth Skill Size:")
                }
                .padding(.horizontal)
                Text("\(Int(maximums[3]))")
                    .bold()
            }
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Add Skill") {
                    createSkill(newSkill: try! Skill(name: iName, maximums: maximums.map({Int($0)})))
                    dismiss()
                }
            }
            .padding([.bottom,.trailing])
        }
    }
}

struct AddSkillView_Previews: PreviewProvider {
    static var previews: some View {
        AddSkillView()
    }
}
