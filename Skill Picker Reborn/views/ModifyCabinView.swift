//
//  ModifyCabinView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import SwiftUI

struct ModifyCabinView: View {
    @EnvironmentObject private var data: CampData
    @State private var newName: String = ""
    @State private var seniorSelection = nullSenior.id
    @State private var juniorSelection = nullJunior.id
    private var targetCabin: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:", text: $newName)
                .padding(.bottom)
            Picker("Senior", selection: $seniorSelection) {
                Text("None").tag(nullSenior.id)
                if(data.leaders.count > 0){
                    ForEach(0...(data.leaders.count-1), id: \.self){
                        if(data.leaders[$0].senior){
                            Text(data.leaders[$0].fName+" "+data.leaders[$0].lName).tag(data.leaders[$0].id)
                        }
                    }
                }
            }
            Picker("Junior", selection: $juniorSelection) {
                Text("None").tag(nullJunior.id)
                if(data.leaders.count > 0){
                    ForEach(0...(data.leaders.count-1), id: \.self){
                        if(!data.leaders[$0].senior){
                            Text(data.leaders[$0].fName+" "+data.leaders[$0].lName).tag(data.leaders[$0].id)
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Save Changes") {
                    if(seniorSelection == nullSenior.id && juniorSelection == nullJunior.id){
                        changeCabinLeaders(cabinName: targetCabin, targetSenior: nullSenior, targetJunior: nullJunior, data: data)
                    } else if(seniorSelection == nullSenior.id){
                        changeCabinLeaders(cabinName: targetCabin,
                                           targetSenior: nullSenior,
                                           targetJunior: data.leaders.first(where: {$0.id == juniorSelection})!, data: data)
                    } else if(juniorSelection == nullJunior.id){
                        changeCabinLeaders(cabinName: targetCabin,
                                           targetSenior: data.leaders.first(where: {$0.id == seniorSelection})!,
                                           targetJunior: nullJunior, data: data)
                    } else {
                        changeCabinLeaders(cabinName: targetCabin,
                                           targetSenior: data.leaders.first(where: {$0.id == seniorSelection})!,
                                           targetJunior: data.leaders.first(where: {$0.id == juniorSelection})!, data: data)
                    }
                    if(newName != targetCabin){
                        renameCabin(oldCabin: targetCabin, newCabin: newName, data: data)
                        data.selectedCabin = newName
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding(.top)
        }
        .padding()
        .frame(width: 270)
        .onAppear(perform: {
            newName = targetCabin
            seniorSelection = data.cabins[targetCabin]!.senior.id
            juniorSelection = data.cabins[targetCabin]!.junior.id
        })
    }
    init(targetCabin: String) {
        self.targetCabin = targetCabin
    }
}

struct ModifyCabinView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyCabinView(targetCabin: "This is a cabin.")
    }
}
