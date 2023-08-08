//
//  AddLeaderView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import SwiftUI

struct AddLeaderView: View {
    @EnvironmentObject private var data: CampData
    @State private var iFName = ""
    @State private var iLName = ""
    @State private var isSenior = false
    @State private var selectedCabin = "Unassigned"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("First Name:", text: $iFName)
            TextField("Last Name:", text: $iLName)
            Picker("Cabin:", selection: $selectedCabin) {
                ForEach(Array(data.cabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            Toggle(isOn: $isSenior){
                Text("Senior:")
            }
            .toggleStyle(.switch)
            .padding(.bottom)
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Leader"){
                    createLeader(newLeader: try! Leader(fName: iFName, lName: iLName, cabin: selectedCabin, senior: isSenior), data: data)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(iFName == "" || iLName == "")
            }
        }
        .frame(width: 255, height: 150)
        .padding()
    }
}

struct AddLeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AddLeaderView()
            .environmentObject(CampData())
    }
}
