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
    @State private var nameAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("First Name:", text: $iFName)
                .padding([.top,.horizontal])
            TextField("Last Name:", text: $iLName)
                .padding(.horizontal)
            Picker("Cabin", selection: $selectedCabin) {
                ForEach(Array(data.cabins.keys).sorted(), id: \.self){
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
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Leader"){
                    if(iFName == "" || iLName == ""){
                        nameAlert.toggle()
                    } else {
                        createLeader(newLeader: try! Leader(fName: iFName, lName: iLName, cabin: selectedCabin, senior: isSenior), data: data)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding([.vertical,.trailing])
            .alert(isPresented: $nameAlert){
                Alert(title: Text("Error!"),
                    message: Text("You must provide a first and last name for the leader."),
                    dismissButton: .default(Text("Dismiss")))
            }
        }
        .frame(width: 290, height: 190)
    }
}

struct AddLeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AddLeaderView()
    }
}
