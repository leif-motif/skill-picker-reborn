//
//  AssignFanaticCamperView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-31.
//

import SwiftUI

struct AssignFanaticCamperView: View {
    private var targetFanatic: String
    @State private var selectedCamper: String = "None"
    @State private var noneCamperAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Text("Warning: This will remove the\ncamper's sixth preferred skill.")
                .bold()
                .padding([.top,.trailing])
            Picker("Camper:", selection: $selectedCamper){
                ForEach(zip(campers.filter{!$0.skills.contains(targetFanatic)}.map(\.fName),campers.filter{!$0.skills.contains(targetFanatic)}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding(.horizontal)
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Camper") {
                    if(selectedCamper != "None"){
                        try! assignCamperToFanatic(targetCamper: campers.first(where: {$0.fName == selectedCamper.components(separatedBy: " ")[0] && $0.lName == selectedCamper.components(separatedBy: " ")[1]})!,
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
