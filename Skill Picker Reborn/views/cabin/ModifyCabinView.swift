/*
 * ModifyCabinView.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2023 Ranger Lake Bible Camp
 *
 * Skill Picker Reborn is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Skill Picker Reborn is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Skill Picker Reborn; if not, see <https://www.gnu.org/licenses/>.
 */

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
