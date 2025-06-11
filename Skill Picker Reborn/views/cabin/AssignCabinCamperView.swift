/*
 * AssignCabinCamperView.swift
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

struct AssignCabinCamperView: View {
    @EnvironmentObject private var data: CampData
    private var targetCabin: String
    @State private var camperInput = ""
    @State private var camperIDs: [String:Camper.ID] = [:]
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
                    data.assignCamperToCabin(targetCamper: data.getCamper(camperID: camperIDs[camperInput.lowercased()]!)!, cabinName: targetCabin)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(!camperIDs.keys.contains(camperInput.lowercased()))
            }
        }
        .padding()
        .frame(width: 290, height: 90)
        .onAppear(perform: {
            for camper in data.c.campers/*.sorted(by: {$0.lName < $1.lName})*/ {
                if(camper.cabin != targetCabin){
                    camperIDs[camper.fName.lowercased()+" "+camper.lName.lowercased()] = camper.id
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
            .environmentObject(CampData())
    }
}
