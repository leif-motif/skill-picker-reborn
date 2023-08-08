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
    @State private var seniorSelection = UUID()
    @State private var juniorSelection = UUID()
    private var targetCabin: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:", text: $newName)
                .padding(.bottom)
            Picker("Senior:", selection: $seniorSelection) {
                Text("None").tag(data.nullSenior.id)
                if(data.leaders.count > 0){
                    ForEach(0...(data.leaders.count-1), id: \.self){
                        if(data.leaders[$0].senior){
                            Text(data.leaders[$0].fName+" "+data.leaders[$0].lName).tag(data.leaders[$0].id)
                        }
                    }
                }
            }
            Picker("Junior:", selection: $juniorSelection) {
                Text("None").tag(data.nullJunior.id)
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
                    if(seniorSelection == data.nullSenior.id && juniorSelection == data.nullJunior.id){
                        changeCabinLeaders(cabinName: targetCabin, targetSenior: data.nullSenior, targetJunior: data.nullJunior, data: data)
                    } else if(seniorSelection == data.nullSenior.id){
                        changeCabinLeaders(cabinName: targetCabin,
                                           targetSenior: data.nullSenior,
                                           targetJunior: data.leaders.first(where: {$0.id == juniorSelection})!, data: data)
                    } else if(juniorSelection == data.nullJunior.id){
                        changeCabinLeaders(cabinName: targetCabin,
                                           targetSenior: data.leaders.first(where: {$0.id == seniorSelection})!,
                                           targetJunior: data.nullJunior, data: data)
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
                .disabled(newName == "" || (data.cabins.keys.contains(newName) && newName != targetCabin))
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
