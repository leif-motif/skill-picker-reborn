/*
 * AssignCabinCamperView.swift
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

struct AssignCabinCamperView: View {
    @EnvironmentObject private var data: CampData
    private var targetCabin: String
    @State private var camperInput = ""
    @State private var camperIDs: [String:UUID] = [:]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            //this really should be replaced with something better but Apple is stupid.
            TextField("Camper:", text: $camperInput)
                .padding(.bottom)
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Camper") {
                    assignCamperToCabin(targetCamper: data.campers.first(where: {$0.id == camperIDs[camperInput]})!, cabinName: targetCabin, data: data)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(!camperIDs.keys.contains(camperInput))
            }
        }
        .padding()
        .frame(width: 290, height: 90)
        .onAppear(perform: {
            for camper in data.campers/*.sorted(by: {$0.lName < $1.lName})*/ {
                if(camper.cabin != targetCabin){
                    camperIDs[camper.fName+" "+camper.lName] = camper.id
                }
            }
            print(camperIDs)
        })
    }
    init(targetCabin: String) {
        self.targetCabin = targetCabin
    }
}

struct AssignCabinCamperView_Previews: PreviewProvider {
    static var previews: some View {
        AssignCabinCamperView(targetCabin: "A")
    }
}
