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
    @State private var firstChoice = ""
    @State private var secondChoice = ""
    @State private var thirdChoice = ""
    @State private var fourthChoice = ""
    @State private var fifthChoice = ""
    @State private var sixthChoice = ""
    @State private var fanaticSelection = "None"
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
                TextField("First:",text: $firstChoice)
                    .padding(.horizontal)
                TextField("Second:",text: $secondChoice)
                    .padding(.horizontal)
                TextField("Third:",text: $thirdChoice)
                    .padding(.horizontal)
                TextField("Fourth:",text: $fourthChoice)
                    .padding(.horizontal)
                TextField("Fifth:",text: $fifthChoice)
                    .padding(.horizontal)
                TextField("Sixth:",text: $sixthChoice)
                    .padding(.horizontal)
                    .disabled(fanaticSelection != "None")
            }
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Camper"){
                    if(fanaticSelection != "None"){
                        try! createCamper(newCamper: try! Camper(fName: iFName, lName: iLName, cabin: selectedCabin, preferredSkills: [firstChoice,secondChoice,thirdChoice,fourthChoice,fifthChoice], fanatic: fanaticSelection))
                    } else {
                        try! createCamper(newCamper: try! Camper(fName: iFName, lName: iLName, cabin: selectedCabin, preferredSkills: [firstChoice,secondChoice,thirdChoice,fourthChoice,fifthChoice,sixthChoice], fanatic: fanaticSelection))
                    }
                    dismiss()
                }
                Spacer()
            }
            .padding([.vertical,.trailing])
        }
    }
}

struct AddCamperView_Previews: PreviewProvider {
    static var previews: some View {
        AddCamperView()
    }
}
