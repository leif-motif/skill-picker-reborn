//
//  AddCabinView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddCabinView: View {
    @State private var iName = ""
    @State private var seniorSelection = nullSenior.id
    @State private var juniorSelection = nullJunior.id
    @State private var nameAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:",text: $iName)
                .padding([.top,.horizontal])
            Picker("Senior", selection: $seniorSelection) {
                Text("None").tag(nullSenior.id)
                if(leaders.count > 0){
                    ForEach(0...(leaders.count-1), id: \.self){
                        if(leaders[$0].senior){
                            Text(leaders[$0].fName+" "+leaders[$0].lName).tag(leaders[$0].id)
                        }
                    }
                }
            }
            .padding([.top,.horizontal])
            Picker("Junior", selection: $juniorSelection) {
                Text("None").tag(nullJunior.id)
                if(leaders.count > 0){
                    ForEach(0...(leaders.count-1), id: \.self){
                        if(!leaders[$0].senior){
                            Text(leaders[$0].fName+" "+leaders[$0].lName).tag(leaders[$0].id)
                        }
                    }
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
                    } else if(seniorSelection == nullSenior.id && juniorSelection == nullJunior.id){
                        createCabin(cabinName: iName, targetSenior: nullSenior, targetJunior: nullJunior)
                        dismiss()
                    } else if(seniorSelection == nullSenior.id){
                        createCabin(cabinName: iName,
                                    targetSenior: nullSenior,
                                    targetJunior: leaders.first(where: {$0.id == juniorSelection})!)
                        dismiss()
                    } else if(juniorSelection == nullJunior.id){
                        createCabin(cabinName: iName,
                                    targetSenior: leaders.first(where: {$0.id == seniorSelection})!,
                                    targetJunior: nullJunior)
                        dismiss()
                    } else {
                        createCabin(cabinName: iName,
                                    targetSenior: leaders.first(where: {$0.id == seniorSelection})!,
                                    targetJunior: leaders.first(where: {$0.id == juniorSelection})!)
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
