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
    @State private var selectedLeader: String = "None"
    @State private var noneLeaderAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Leader:", selection: $selectedLeader){
                ForEach(zip(leaders.filter{$0.skills[skillPeriod] != targetSkill}.map(\.fName),leaders.filter{$0.skills[skillPeriod] != targetSkill}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding()
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Leader") {
                    if(selectedLeader != "None"){
                        assignLeaderToSkill(targetLeader: leaders.first(where: {$0.fName == selectedLeader.components(separatedBy: " ")[0] && $0.lName == selectedLeader.components(separatedBy: " ")[1]})!,
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
