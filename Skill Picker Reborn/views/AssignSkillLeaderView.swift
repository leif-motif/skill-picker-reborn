//
//  AssignLeaderToSkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-30.
//

import SwiftUI

struct AssignSkillLeaderView: View {
    private var targetSkill: String
    private var skillPeriod: Int
    @State private var selectedLeader: String = "None"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Leader:", selection: $selectedLeader){
                ForEach(zip(fooLeaders.filter{$0.skills[skillPeriod] != targetSkill}.map(\.fName),fooLeaders.filter{$0.skills[skillPeriod] != targetSkill}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding([.top,.horizontal])
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Leader") {
                    assignLeaderToSkill(targetLeader: fooLeaders.first(where: {$0.fName == selectedLeader.components(separatedBy: " ")[0] && $0.lName == selectedLeader.components(separatedBy: " ")[1]})!,
                                        skillName: targetSkill, period: skillPeriod)
                    dismiss()
                }
            }
            .padding([.bottom,.trailing])
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
