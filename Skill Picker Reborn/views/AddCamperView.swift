//
//  AddCamperView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddCamperView: View {
    @State private var iFName = ""
    @State private var iLName = ""
    @State private var selectedCabin = "Unassigned"
    @State private var preferredSkills = ["","","","","",""]
    @State private var fanaticSelection = "None"
    @State private var nameAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("First Name:",text: $iFName)
                .padding([.top,.horizontal])
            TextField("Last Name:",text: $iLName)
                .padding([.horizontal])
            Picker("Cabin", selection: $selectedCabin) {
                ForEach(Array(cabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
                .padding([.horizontal])
            Picker("Fanatic", selection: $fanaticSelection){
                Text("None").tag("None")
                ForEach(Array(fanatics.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
                .padding([.horizontal])
            Text("Preferred Skills:")
                .bold()
                .padding([.top,.trailing])
            Group {
                TextField("First:",text: $preferredSkills[0])
                    .padding(.horizontal)
                TextField("Second:",text: $preferredSkills[1])
                    .padding(.horizontal)
                TextField("Third:",text: $preferredSkills[2])
                    .padding(.horizontal)
                TextField("Fourth:",text: $preferredSkills[3])
                    .padding(.horizontal)
                TextField("Fifth:",text: $preferredSkills[4])
                    .padding(.horizontal)
                TextField("Sixth:",text: $preferredSkills[5])
                    .padding(.horizontal)
                    .disabled(fanaticSelection != "None")
            }
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Camper"){
                    if(iFName == "" || iLName == ""){
                        nameAlert.toggle()
                    } else if(fanaticSelection != "None"){
                        preferredSkills.remove(at: 5)
                        try! createCamper(newCamper: try! Camper(fName: iFName, lName: iLName, cabin: selectedCabin, preferredSkills: preferredSkills, fanatic: fanaticSelection))
                        dismiss()
                    } else {
                        try! createCamper(newCamper: try! Camper(fName: iFName, lName: iLName, cabin: selectedCabin, preferredSkills: preferredSkills, fanatic: fanaticSelection))
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding([.vertical,.trailing])
        }
        .alert(isPresented: $nameAlert){
            Alert(title: Text("Error!"),
                  message: Text("You must provide a first and last name for the camper."),
                  dismissButton: .default(Text("Dismiss")))
        }
        .frame(width: 300, height: 400)
    }
}

struct AddCamperView_Previews: PreviewProvider {
    static var previews: some View {
        AddCamperView()
    }
}
