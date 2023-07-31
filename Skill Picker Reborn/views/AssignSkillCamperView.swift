//
//  AssignSkillCamperView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-31.
//

import SwiftUI

struct AssignSkillCamperView: View {
    private var targetSkill: String
    private var skillPeriod: Int
    @State private var selectedCamper: String = "None"
    @State private var noneCamperAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Camper:", selection: $selectedCamper){
                ForEach(zip(campers.filter{$0.skills[skillPeriod] != targetSkill}.map(\.fName),campers.filter{$0.skills[skillPeriod] != targetSkill}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding()
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Assign Camper") {
                    if(selectedCamper != "None"){
                        try! assignCamperToSkill(targetCamper: campers.first(where: {$0.fName == selectedCamper.components(separatedBy: " ")[0] && $0.lName == selectedCamper.components(separatedBy: " ")[1]})!,
                                                 skillName: targetSkill, period: skillPeriod)
                        dismiss()
                    } else {
                        noneCamperAlert.toggle()
                    }
                }
            }
            .padding([.bottom,.trailing])
        }
        .alert(isPresented: $noneCamperAlert) {
            Alert(title: Text("Error!"),
                  message: Text("A camper to assign to the skill must be selected."),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
    init(targetSkill: String, skillPeriod: Int) {
        self.targetSkill = targetSkill
        self.skillPeriod = skillPeriod
    }
}

struct AssignSkillCamperView_Previews: PreviewProvider {
    static var previews: some View {
        AssignSkillCamperView(targetSkill: "Test", skillPeriod: 0)
    }
}
