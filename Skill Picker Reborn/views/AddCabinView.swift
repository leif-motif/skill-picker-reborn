//
//  AddCabinView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddCabinView: View {
    @State private var iName = ""
    @State private var seniorSelection = "None"
    @State private var juniorSelection = "None"
    @State private var nameAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:",text: $iName)
                .padding([.top,.horizontal])
            Picker("Senior", selection: $seniorSelection) {
                Text("None").tag("None")
                ForEach(zip(leaders.filter{$0.senior}.map(\.fName),leaders.filter{$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding([.top,.horizontal])
            Picker("Junior", selection: $juniorSelection) {
                Text("None").tag("None")
                ForEach(zip(leaders.filter{!$0.senior}.map(\.fName),leaders.filter{!$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
                .padding([.horizontal])
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Cabin"){
                    if(iName == ""){
                        nameAlert.toggle()
                    //gets the first element of the leader array where the selection's first and last names are equal to the element's first and last names
                    } else if(seniorSelection == "None" && juniorSelection == "None"){
                        createCabin(cabinName: iName, targetSenior: nullSenior, targetJunior: nullJunior)
                        dismiss()
                    } else if(seniorSelection == "None"){
                        createCabin(cabinName: iName,
                                    targetSenior: nullSenior,
                                    targetJunior: leaders.first(where: {$0.fName == juniorSelection.components(separatedBy: " ")[0] && $0.lName == juniorSelection.components(separatedBy: " ")[1]})!)
                        dismiss()
                    } else if(juniorSelection == "None"){
                        createCabin(cabinName: iName,
                                    targetSenior: leaders.first(where: {$0.fName == seniorSelection.components(separatedBy: " ")[0] && $0.lName == seniorSelection.components(separatedBy: " ")[1]})!,
                                    targetJunior: nullJunior)
                        dismiss()
                    } else {
                        createCabin(cabinName: iName,
                                    targetSenior: leaders.first(where: {$0.fName == seniorSelection.components(separatedBy: " ")[0] && $0.lName == seniorSelection.components(separatedBy: " ")[1]})!,
                                    targetJunior: leaders.first(where: {$0.fName == juniorSelection.components(separatedBy: " ")[0] && $0.lName == juniorSelection.components(separatedBy: " ")[1]})!)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .alert(isPresented: $nameAlert){
                Alert(title: Text("Error!"),
                      message: Text("You must provide a first and last name for the leader."),
                      dismissButton: .default(Text("Dismiss")))
            }
            .padding([.vertical,.trailing])
        }
        .frame(width: 250, height: 170)
    }
}

struct AddCabinView_Previews: PreviewProvider {
    static var previews: some View {
        AddCabinView()
    }
}
