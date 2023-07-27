//
//  AddFanaticView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddFanaticView: View {
    @State private var iName = ""
    @State private var firstSkill = false
    @State private var secondSkill = false
    @State private var thirdSkill = false
    @State private var fourthSkill = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:", text: $iName)
                .padding(.all)
            Toggle(isOn: $firstSkill) {
                Text("First Skill:")
            }
            .padding(.horizontal)
            .toggleStyle(.switch)
            Toggle(isOn: $secondSkill) {
                Text("Second Skill:")
            }
            .padding(.horizontal)
            .toggleStyle(.switch)
            Toggle(isOn: $thirdSkill) {
                Text("Third Skill:")
            }
            .padding(.horizontal)
            .toggleStyle(.switch)
            Toggle(isOn: $fourthSkill) {
                Text("Fourth Skill:")
            }
            .toggleStyle(.switch)
            .padding([.bottom,.horizontal])
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Add Skill") {
                    //add fanatic
                    dismiss()
                }
            }
            .padding([.bottom,.trailing])
        }
    }
}

struct AddFanaticView_Previews: PreviewProvider {
    static var previews: some View {
        AddFanaticView()
    }
}
