//
//  RemoveFanaticCamperView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-31.
//

import SwiftUI

struct RemoveFanaticCamperView: View {
    private var camperSelection: Set<Camper.ID>
    private var fanaticName: String
    @State private var sixthPreferredSkill: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Text("New Sixth Preferred Skill:")
                .padding([.top,.horizontal])
            TextField("", text: $sixthPreferredSkill)
                .padding([.bottom,.horizontal])
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Remove Camper") {
                    try! removeCamperFromFanatic(camperSelection: camperSelection, fanaticName: fanaticName, newSixthPreferredSkill: sixthPreferredSkill)
                    dismiss()
                }
            }
            .padding([.bottom,.trailing])
        }
    }
    init(camperSelection: Set<Camper.ID>, fanaticName: String){
        self.camperSelection = camperSelection
        self.fanaticName = fanaticName
    }
}
/*
struct RemoveFanaticCamperView_Previews: PreviewProvider {
    static var previews: some View {
        RemoveFanaticCamperView(camperSelection: <#T##Set<Camper.ID>#>, fanaticName: "Paintball")
    }
}*/
