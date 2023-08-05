//
//  AssignFanaticCamperView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-31.
//

import SwiftUI

struct AssignFanaticCamperView: View {
    private var targetFanatic: String
    @State private var selectedCamper = UUID()
    @State private var noneCamperAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Text("Warning: This will remove the\ncamper's sixth preferred skill.")
                .bold()
                .padding([.top,.trailing])
            Picker("Camper:", selection: $selectedCamper){
                ForEach(0...(campers.count-1), id: \.self){
                    if(campers[$0].fanatic != targetFanatic){
                        Text(campers[$0].fName+" "+campers[$0].lName).tag(campers[$0].id)
                    }
                }
            }
            .padding(.horizontal)
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Camper") {
                    let targetCamper: Camper? = campers.first(where: {$0.id == selectedCamper})
                    if(targetCamper != nil){
                        try! assignCamperToFanatic(targetCamper: targetCamper!,
                                                   fanaticName: targetFanatic)
                        dismiss()
                    } else {
                        noneCamperAlert.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding([.vertical,.trailing])
        }
        .frame(width: 280, height: 141)
        .alert(isPresented: $noneCamperAlert) {
            Alert(title: Text("Error!"),
                  message: Text("A camper to assign to the fanatic skill must be selected."),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
    init(targetFanatic: String) {
        self.targetFanatic = targetFanatic
    }
}

struct AssignFanaticCamperView_Previews: PreviewProvider {
    static var previews: some View {
        AssignFanaticCamperView(targetFanatic: "Paintball")
    }
}
