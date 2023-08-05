//
//  AssignFanaticLeaderView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-31.
//

import SwiftUI

struct AssignFanaticLeaderView: View {
    private var targetFanatic: String
    @State private var selectedLeader = UUID()
    @State private var noneLeaderAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Leader:", selection: $selectedLeader){
                ForEach(0...(leaders.count-1), id: \.self){
                    if(!leaders[$0].skills.contains(targetFanatic)){
                        Text(leaders[$0].fName+" "+leaders[$0].lName).tag(leaders[$0].id)
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
                    let targetLeader: Leader? = leaders.first(where: {$0.id == selectedLeader})
                    if(targetLeader != nil){
                        try! assignLeaderToFanatic(targetLeader: targetLeader!,
                                                   fanaticName: targetFanatic)
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
