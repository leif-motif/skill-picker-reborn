//
//  AssignFanaticLeaderView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-31.
//

import SwiftUI

struct AssignFanaticLeaderView: View {
    private var targetFanatic: String
    @State private var selectedLeader: String = "None"
    @State private var noneLeaderAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Leader:", selection: $selectedLeader){
                ForEach(zip(leaders.filter{!$0.skills.contains(targetFanatic)}.map(\.fName),leaders.filter{!$0.skills.contains(targetFanatic)}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding()
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Leader") {
                    if(selectedLeader != "None"){
                        try! assignLeaderToFanatic(targetLeader: leaders.first(where: {$0.fName == selectedLeader.components(separatedBy: " ")[0] && $0.lName == selectedLeader.components(separatedBy: " ")[1]})!,
                                                   fanaticName: targetFanatic)
                        dismiss()
                    } else {
                        noneLeaderAlert.toggle()
                    }
                }
            }
            .padding([.bottom,.trailing])
        }
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
