//
//  AssignLeaderToSkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-30.
//

import SwiftUI

struct AssignLeaderToSkillView: View {
    private var targetSkill: String
    private var skillPeriod: Int
    @State private var leaderSelection: String = "None"
    var body: some View {
        Form {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Picker("Leader:", selection: $leaderSelection){
                //change this to only select leaders that are not assigned to the skill
                ForEach(zip(fooLeaders.filter{$0.senior}.map(\.fName),fooLeaders.filter{$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
        }
    }
    init(targetSkill: String, skillPeriod: Int) {
        self.targetSkill = targetSkill
        self.skillPeriod = skillPeriod
    }
}

struct AssignLeaderToSkillView_Previews: PreviewProvider {
    static var previews: some View {
        AssignLeaderToSkillView(targetSkill: "Test", skillPeriod: 0)
    }
}
