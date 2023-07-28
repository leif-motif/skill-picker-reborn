//
//  AddLeaderView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import SwiftUI

struct AddLeaderView: View {
    @State private var iFName = ""
    @State private var iLName = ""
    @State private var isSenior = false
    @State private var selectedCabin = "Unassigned"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("First Name:", text: $iFName)
                .padding([.top,.horizontal])
            TextField("Last Name:", text: $iLName)
                .padding(.horizontal)
            Picker("Cabin", selection: $selectedCabin) {
                ForEach(Array(fooCabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
                .padding(.horizontal)
            Toggle(isOn: $isSenior){
                Text("Senior:")
            }
            .toggleStyle(.switch)
            .padding(.horizontal)
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Leader"){
                    createLeader(newLeader: try! Leader(fName: iFName, lName: iLName, cabin: selectedCabin, senior: isSenior))
                    dismiss()
                }
            }
            .padding([.vertical,.trailing])
        }
    }
}

struct AddLeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AddLeaderView()
    }
}
