//
//  AddFanaticView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddFanaticView: View {
    @EnvironmentObject private var data: CampData
    @State private var iName = ""
    @State private var firstSkill = false
    @State private var secondSkill = false
    @State private var thirdSkill = false
    @State private var fourthSkill = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:", text: $iName)
                .padding(.bottom)
            Toggle(isOn: $firstSkill) {
                Text("First Skill:")
            }
            .toggleStyle(.switch)
            Toggle(isOn: $secondSkill) {
                Text("Second Skill:")
            }
            .toggleStyle(.switch)
            Toggle(isOn: $thirdSkill) {
                Text("Third Skill:")
            }
            .toggleStyle(.switch)
            Toggle(isOn: $fourthSkill) {
                Text("Fourth Skill:")
            }
            .toggleStyle(.switch)
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Add Fanatic") {
                    createFanatic(newFanatic: try! Fanatic(name: iName, activePeriods: [firstSkill,secondSkill,thirdSkill,fourthSkill]), data: data)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding(.top)
        }
        .frame(width: 250, height: 200)
        .padding()
    }
}

struct AddFanaticView_Previews: PreviewProvider {
    static var previews: some View {
        AddFanaticView()
    }
}
