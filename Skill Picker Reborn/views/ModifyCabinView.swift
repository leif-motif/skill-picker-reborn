//
//  ModifyCabinView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import SwiftUI

struct ModifyCabinView: View {
    @EnvironmentObject private var data: CampData
    @State private var iName: String = ""
    private var editing: Bool
    @State private var seniorSelection = UUID()
    @State private var juniorSelection = UUID()
    private var targetCabin: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:", text: $iName)
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
                if(editing){
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
                        if(iName != targetCabin){
                            renameCabin(oldCabin: targetCabin, newCabin: iName, data: data)
                            data.selectedCabin = iName
                        }
                        dismiss()
                    }
                    .disabled(iName == "" || (data.cabins.keys.contains(iName) && iName != targetCabin))
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                } else {
                    Button("Create Cabin"){
                        if(seniorSelection == data.nullSenior.id && juniorSelection == data.nullJunior.id){
                            createCabin(cabinName: iName, targetSenior: data.nullSenior, targetJunior: data.nullJunior, data: data)
                        } else if(seniorSelection == data.nullSenior.id){
                            createCabin(cabinName: iName,
                                        targetSenior: data.nullSenior,
                                        targetJunior: data.leaders.first(where: {$0.id == juniorSelection})!, data: data)
                        } else if(juniorSelection == data.nullJunior.id){
                            createCabin(cabinName: iName,
                                        targetSenior: data.leaders.first(where: {$0.id == seniorSelection})!,
                                        targetJunior: data.nullJunior, data: data)
                        } else {
                            createCabin(cabinName: iName,
                                        targetSenior: data.leaders.first(where: {$0.id == seniorSelection})!,
                                        targetJunior: data.leaders.first(where: {$0.id == juniorSelection})!,
                                        data: data)
                        }
                        data.selectedCabin = iName
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(iName == "" || data.cabins.keys.contains(iName))
                }
            }
            .padding(.top)
        }
        .padding()
        .frame(width: 270)
        .onAppear(perform: {
            iName = targetCabin
            if(editing){
                seniorSelection = data.cabins[targetCabin]!.senior.id
                juniorSelection = data.cabins[targetCabin]!.junior.id
            } else {
                seniorSelection = data.nullSenior.id
                juniorSelection = data.nullJunior.id
            }
        })
    }
    init(targetCabin: String = "") {
        self.targetCabin = targetCabin
        self.editing = targetCabin != ""
    }
}

struct ModifyCabinView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyCabinView()
            .environmentObject(CampData())
    }
}
