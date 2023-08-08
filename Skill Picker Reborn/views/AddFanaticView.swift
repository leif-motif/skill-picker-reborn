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
    @State private var activePeriods = [false,false,false,false]
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
                Button("Add Fanatic") {
                    createFanatic(newFanatic: try! Fanatic(name: iName, activePeriods: activePeriods), data: data)
                    dismiss()
                }
                .disabled(iName == "" || data.skills.keys.contains(iName) || activePeriods == [false,false,false,false])
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
            .environmentObject(CampData())
    }
}
