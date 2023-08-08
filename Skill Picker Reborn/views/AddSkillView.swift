//
//  AddSkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddSkillView: View {
    @EnvironmentObject private var data: CampData
    @State private var iName = ""
    @State private var maximums = [1, 1, 1 ,1]
    private let range = 0...255
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
                Button("Add Skill") {
                    //There's probably a better way to do this but I no longer care.
                    for i in 0...3 {
                        if(maximums[i] < 0){
                            maximums[i] = 0
                        } else if(maximums[i] > 255){
                            maximums[i] = 255
                        }
                    }
                    createSkill(newSkill: try! Skill(name: iName, maximums: maximums), data: data)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(iName == "" || data.skills.keys.contains(iName) || maximums == [0,0,0,0])
            }
            .padding(.top)
        }
        .padding()
        .frame(width: 300, height: 270)
    }
}

struct AddSkillView_Previews: PreviewProvider {
    static var previews: some View {
        AddSkillView()
            .environmentObject(CampData())
    }
}
