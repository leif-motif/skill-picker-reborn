/*
 * ModifyCabinView.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2025 Ranger Lake Bible Camp
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
    @State private var seniorSelection = Leader.ID()
    @State private var juniorSelection = Leader.ID()
    private var targetCabin: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("Name:", text: $iName)
                .padding(.bottom)
            Picker("Senior:", selection: $seniorSelection) {
                Text("None").tag(data.c.nullSenior.id)
                if(data.c.leaders.count > 0){
                    ForEach(Array(data.c.leaders)){ leader in
                        if(leader.senior){
                            Text(leader.fName+" "+leader.lName).tag(leader.id)
                        }
                    }
                }
            }
            Picker("Junior:", selection: $juniorSelection) {
                Text("None").tag(data.c.nullJunior.id)
                if(data.c.leaders.count > 0){
                    ForEach(Array(data.c.leaders)){ leader in
                        if(!leader.senior){
                            Text(leader.fName+" "+leader.lName).tag(leader.id)
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
                        data.objectWillChange.send()
                        if(seniorSelection == data.c.nullSenior.id && juniorSelection == data.c.nullJunior.id){
                            data.changeCabinLeaders(cabinName: targetCabin, targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
                        } else if(seniorSelection == data.c.nullSenior.id){
                            data.changeCabinLeaders(cabinName: targetCabin,
                                               targetSenior: data.c.nullSenior,
                                               targetJunior: data.getLeader(leaderID: juniorSelection)!, usingInternally: true)
                        } else if(juniorSelection == data.c.nullJunior.id){
                            data.changeCabinLeaders(cabinName: targetCabin,
                                               targetSenior: data.getLeader(leaderID: seniorSelection)!,
                                               targetJunior: data.c.nullJunior, usingInternally: true)
                        } else {
                            data.changeCabinLeaders(cabinName: targetCabin,
                                               targetSenior: data.getLeader(leaderID: seniorSelection)!,
                                               targetJunior: data.getLeader(leaderID: juniorSelection)!, usingInternally: true)
                        }
                        if(iName != targetCabin){
                            data.renameCabin(oldCabin: targetCabin, newCabin: iName, usingInternally: true)
                            data.selectedCabin = iName
                        }
                        #warning("TODO: handle group undo when cabin's name needs modifying")
                        dismiss()
                    }
                    .disabled(iName == "" || (data.c.cabins.keys.contains(iName) && iName != targetCabin))
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                } else {
                    Button("Create Cabin"){
                        if(seniorSelection == data.c.nullSenior.id && juniorSelection == data.c.nullJunior.id){
                            data.createCabin(cabinName: iName, targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior)
                        } else if(seniorSelection == data.c.nullSenior.id){
                            data.createCabin(cabinName: iName,
                                        targetSenior: data.c.nullSenior,
                                        targetJunior: data.getLeader(leaderID: juniorSelection)!)
                        } else if(juniorSelection == data.c.nullJunior.id){
                            data.createCabin(cabinName: iName,
                                        targetSenior: data.getLeader(leaderID: seniorSelection)!,
                                        targetJunior: data.c.nullJunior)
                        } else {
                            data.createCabin(cabinName: iName,
                                        targetSenior: data.getLeader(leaderID: seniorSelection)!,
                                        targetJunior: data.getLeader(leaderID: juniorSelection)!)
                        }
                        data.selectedCabin = iName
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(iName == "" || data.c.cabins.keys.contains(iName))
                }
            }
            .padding(.top)
        }
        .padding()
        .frame(width: 270)
        .onAppear(perform: {
            iName = targetCabin
            if(editing){
                seniorSelection = data.c.cabins[targetCabin]!.senior.id
                juniorSelection = data.c.cabins[targetCabin]!.junior.id
            } else {
                seniorSelection = data.c.nullSenior.id
                juniorSelection = data.c.nullJunior.id
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
