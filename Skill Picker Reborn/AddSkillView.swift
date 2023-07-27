//
//  AddSkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddSkillView: View {
    @State private var iName = ""
    @State private var firstMax = 1.0
    @State private var secondMax = 1.0
    @State private var thirdMax = 1.0
    @State private var fourthMax = 1.0
    private var range = 0.0...20.0
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:", text: $iName)
                .padding(.all)
            Slider(value: $firstMax, in: range, step: 1){
                Text("First Skill Size:")
            }
            .padding(.horizontal)
            Text("\(Int(firstMax))")
                .bold()
            Slider(value: $secondMax, in: range, step: 1){
                Text("Second Skill Size:")
            }
            .padding(.horizontal)
            Text("\(Int(secondMax))")
                .bold()
            Slider(value: $thirdMax, in: range, step: 1){
                Text("Third Skill Size:")
            }
            .padding(.horizontal)
            Text("\(Int(thirdMax))")
                .bold()
            Slider(value: $fourthMax, in: range, step: 1){
                Text("Fourth Skill Size:")
            }
            .padding(.horizontal)
            Text("\(Int(fourthMax))")
                .bold()
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Add Skill") {
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
