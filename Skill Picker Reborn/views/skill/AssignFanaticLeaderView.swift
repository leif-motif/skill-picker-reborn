/*
 * AssignFanaticLeaderView.swift
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

struct AssignFanaticLeaderView: View {
    @EnvironmentObject private var data: CampData
    private var targetFanatic: String
    @State private var selectedLeader = UUID()
    @State private var noneLeaderAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Leader:", selection: $selectedLeader){
                ForEach(0...(data.leaders.count-1), id: \.self){
                    if(!data.leaders[$0].skills.contains(targetFanatic)){
                        Text(data.leaders[$0].fName+" "+data.leaders[$0].lName).tag(data.leaders[$0].id)
                    }
                }
            }
            .padding()
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Leader") {
                    let targetLeader: Leader? = data.leaders.first(where: {$0.id == selectedLeader})
                    if(targetLeader != nil){
                        try! assignLeaderToFanatic(targetLeader: targetLeader!,
                                                   fanaticName: targetFanatic,
                                                   data: data)
                        dismiss()
                    } else {
                        noneLeaderAlert.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding([.bottom,.trailing])
        }
        .frame(width: 270, height: 90)
        .alert(isPresented: $noneLeaderAlert) {
            Alert(title: Text("Error!"),
                  message: Text("A leader to assign to the fanatic skill must be selected."),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
    init(targetFanatic: String) {
        self.targetFanatic = targetFanatic
    }
}

struct AssignFanaticLeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AssignFanaticLeaderView(targetFanatic: "Test")
    }
}
