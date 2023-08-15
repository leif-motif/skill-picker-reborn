/*
 * AddLeaderView.swift
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

struct AddLeaderView: View {
    @EnvironmentObject private var data: CampData
    @State private var iFName = ""
    @State private var iLName = ""
    @State private var isSenior = false
    @State private var selectedCabin = "Unassigned"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("First Name:", text: $iFName)
            TextField("Last Name:", text: $iLName)
            Picker("Cabin:", selection: $selectedCabin) {
                ForEach(Array(data.cabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            Toggle(isOn: $isSenior){
                Text("Senior:")
            }
            .toggleStyle(.switch)
            .padding(.bottom)
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Create Leader"){
                    createLeader(newLeader: try! Leader(fName: iFName, lName: iLName, cabin: selectedCabin, senior: isSenior), data: data)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(iFName == "" || iLName == "" || !humanIsUnique(fName: iFName, lName: iLName, humanArray: data.leaders))
            }
        }
        .frame(width: 255, height: 150)
        .padding()
    }
}

struct AddLeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AddLeaderView()
            .environmentObject(CampData())
    }
}
