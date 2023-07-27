//
//  AddCabinView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddCabinView: View {
    @State private var iName = ""
    @State private var seniorSelection = "null null"
    @State private var juniorSelection = "null null"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:",text: $iName)
                .padding([.top,.horizontal])
            Picker("Senior", selection: $seniorSelection) {
                ForEach(zip(fooLeaders.filter{$0.senior}.map(\.fName),fooLeaders.filter{$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding([.top,.horizontal])
            Picker("Junior", selection: $juniorSelection) {
                ForEach(zip(fooLeaders.filter{!$0.senior}.map(\.fName),fooLeaders.filter{!$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
                .padding([.horizontal])
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Cabin"){
                    //IF THERE ARE REFERENCE ERRORS, LOOK HERE FOR WHERE EVERYTHING WENT WRONG.
                    
                    //gets the first element of the leader array where the selection's first and last names are equal to the element's first and last names
                    var targetSenior = fooLeaders.first(where: {$0.fName == seniorSelection.components(separatedBy: " ")[0] && $0.lName == seniorSelection.components(separatedBy: " ")[1]})!
                    var targetJunior = fooLeaders.first(where: {$0.fName == juniorSelection.components(separatedBy: " ")[0] && $0.lName == juniorSelection.components(separatedBy: " ")[1]})!
                    //check if leaders are already assigned to a cabin
                    if(targetSenior.cabin != "Unassigned"){
                        fooCabins[targetSenior.cabin]!.senior = fooLeaders[1]
                    }
                    targetSenior.cabin = iName
                    if(targetJunior.cabin != "Unassigned"){
                        fooCabins[targetJunior.cabin]!.junior = fooLeaders[0]
                    }
                    targetJunior.cabin = iName
                    fooCabins[iName] = try! Cabin(name: iName, senior: targetSenior, junior: targetJunior)
                    dismiss()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.vertical,.trailing])
        }
    }
}

struct AddCabinView_Previews: PreviewProvider {
    static var previews: some View {
        AddCabinView()
    }
}
