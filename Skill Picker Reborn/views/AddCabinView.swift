//
//  AddCabinView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-26.
//

import SwiftUI

struct AddCabinView: View {
    @EnvironmentObject private var data: CampData
    @State private var iName = ""
    @State private var seniorSelection = UUID()
    @State private var juniorSelection = UUID()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:",text: $iName)
                .padding(.bottom)
            Picker("Senior", selection: $seniorSelection) {
                Text("None").tag(data.nullSenior.id)
                if(data.leaders.count > 0){
                    ForEach(0...(data.leaders.count-1), id: \.self){
                        if(data.leaders[$0].senior){
                            Text(data.leaders[$0].fName+" "+data.leaders[$0].lName).tag(data.leaders[$0].id)
                        }
                    }
                }
            }
            Picker("Junior", selection: $juniorSelection) {
                Text("None").tag(data.nullJunior.id)
                if(data.leaders.count > 0){
                    ForEach(0...(data.leaders.count-1), id: \.self){
                        if(!data.leaders[$0].senior){
                            Text(data.leaders[$0].fName+" "+data.leaders[$0].lName).tag(data.leaders[$0].id)
                        }
                    }
                }
            }
            .padding(.bottom)
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Cabin"){
                    if(seniorSelection == data.nullSenior.id && juniorSelection == data.nullJunior.id){
                        createCabin(cabinName: iName, targetSenior: data.nullSenior, targetJunior: data.nullJunior, data: data)
                        dismiss()
                    } else if(seniorSelection == data.nullSenior.id){
                        createCabin(cabinName: iName,
                                    targetSenior: data.nullSenior,
                                    targetJunior: data.leaders.first(where: {$0.id == juniorSelection})!, data: data)
                        dismiss()
                    } else if(juniorSelection == data.nullJunior.id){
                        createCabin(cabinName: iName,
                                    targetSenior: data.leaders.first(where: {$0.id == seniorSelection})!,
                                    targetJunior: data.nullJunior, data: data)
                        dismiss()
                    } else {
                        createCabin(cabinName: iName,
                                    targetSenior: data.leaders.first(where: {$0.id == seniorSelection})!,
                                    targetJunior: data.leaders.first(where: {$0.id == juniorSelection})!,
                                    data: data)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(iName == "" || data.cabins.keys.contains(iName))
            }
        }
        .padding()
        .frame(width: 250, height: 170)
        .onAppear(perform: {
            seniorSelection = data.nullSenior.id
            juniorSelection = data.nullJunior.id
        })
    }
}

struct AddCabinView_Previews: PreviewProvider {
    static var previews: some View {
        AddCabinView()
    }
}
