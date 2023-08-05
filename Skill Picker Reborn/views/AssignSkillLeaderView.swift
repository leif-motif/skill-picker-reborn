//
//  AssignSkillLeaderView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-30.
//

import SwiftUI

struct AssignSkillLeaderView: View {
    private var targetSkill: String
    private var skillPeriod: Int
    @State private var selectedLeader = UUID()
    @State private var noneLeaderAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Leader:", selection: $selectedLeader){
                ForEach(0...(leaders.count-1), id: \.self){
                    if(!skills[targetSkill]!.leaders[skillPeriod].contains(leaders[$0])){
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
                        assignLeaderToSkill(targetLeader: targetLeader!,
                                            skillName: targetSkill, period: skillPeriod)
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
                  message: Text("A leader to assign to the skill must be selected."),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
    init(targetSkill: String, skillPeriod: Int) {
        self.targetSkill = targetSkill
        self.skillPeriod = skillPeriod
    }
}

struct AssignSkillLeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AssignSkillLeaderView(targetSkill: "Test", skillPeriod: 0)
    }
}
