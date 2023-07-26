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
    @State private var fanatic = "None"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("First Name:",text: $iFName)
                .padding([.top,.horizontal])
            TextField("Last Name:",text: $iLName)
                .padding([.horizontal])
            Picker("Cabin", selection: $selectedCabin) {
                ForEach(Array(fooCabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
                .padding([.horizontal])
            Picker("Fanatic", selection: $fanatic){
                Text("None").tag("None")
                Text("Tubing").tag("Tubing")
                Text("Paintball").tag("Paintball")
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
                    .disabled(fanatic != "None")
            }
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Camper"){
                    var newCamper = try! Camper(fName: iFName, lName: iLName, cabin: selectedCabin)
                    fooCampers.append(newCamper)
                    fooCabins[selectedCabin]?.campers.append(newCamper)
                    dismiss()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.vertical,.trailing])
        }
    }
}

struct AddCamperView_Previews: PreviewProvider {
    static var previews: some View {
        AddCamperView()
    }
}
