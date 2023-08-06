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
    @State private var preferredSkills = ["None","None","None","None","None","None"]
    @State private var fanaticSelection = "None"
    @State private var nameAlert = false
    @State private var skillAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("First Name:",text: $iFName)
            TextField("Last Name:",text: $iLName)
            Picker("Cabin:", selection: $selectedCabin) {
                ForEach(Array(cabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            Picker("Fanatic:", selection: $fanaticSelection){
                Text("None").tag("None")
                ForEach(Array(fanatics.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding(.bottom)
            Text("Preferred Skills:")
                .bold()
            Group {
                Picker("First:", selection: $preferredSkills[0]){
                    ForEach(Array(skills.keys).sorted().filter({!fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Second:", selection: $preferredSkills[1]){
                    ForEach(Array(skills.keys).sorted().filter({!fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Third:", selection: $preferredSkills[2]){
                    ForEach(Array(skills.keys).sorted().filter({!fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Fourth:", selection: $preferredSkills[3]){
                    ForEach(Array(skills.keys).sorted().filter({!fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Fifth:", selection: $preferredSkills[4]){
                    ForEach(Array(skills.keys).sorted().filter({!fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Sixth:", selection: $preferredSkills[5]){
                    ForEach(Array(skills.keys).sorted().filter({!fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
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
                    } else {
                        preferredSkills.removeAll(where: {$0 == "None"})
                        if(preferredSkills != preferredSkills.uniqued()){
                            preferredSkills = preferredSkills.uniqued()
                        }
                        if(fanaticSelection != "None" && preferredSkills.count == 6){
                            preferredSkills.remove(at: 5)
                        }
                        while(preferredSkills.count < (fanaticSelection == "None" ? 6 : 5)){
                            preferredSkills.append("None")
                        }
                        try! createCamper(newCamper: try! Camper(fName: iFName, lName: iLName, cabin: selectedCabin, preferredSkills: preferredSkills, fanatic: fanaticSelection))
                        dismiss()
                    }
                }
                
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding(.top)
        }
        .alert(isPresented: $nameAlert){
            Alert(title: Text("Error!"),
                  message: Text("You must provide a first and last name for the camper."),
                  dismissButton: .default(Text("Dismiss")))
        }
        .frame(width: 300, height: 370)
        .padding()
    }
}

struct AddCamperView_Previews: PreviewProvider {
    static var previews: some View {
        AddCamperView()
    }
}
