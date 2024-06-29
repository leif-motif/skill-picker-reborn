/*
 * CamperInfoView.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2024 Ranger Lake Bible Camp
 *
 * Skill Picker Reborn is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Skill Picker Reborn is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Skill Picker Reborn; if not, see <https://www.gnu.org/licenses/>.
 */

import SwiftUI

struct CamperInfoView: View {
    @EnvironmentObject private var data: CampData
    @State private var targetCamper: Camper = try! Camper(fName: "", lName: "", cabin: "", preferredSkills: ["None","None","None","None","None","None"], fanatic: "None")
    @State private var newFirstName = ""
    @State private var newLastName = ""
    @State private var newCabin = ""
    @State private var newFanatic = ""
    @State private var newSkills = ["","","",""]
    @State private var newPreferredSkills = ["None","None","None","None","None","None"]
    @State private var duplicateSkillsAlert = false
    @State private var blank = ""
    private var camperID: Camper.ID
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            TextField("First Name:",text: $newFirstName)
            TextField("Last Name:",text: $newLastName)
            Picker("Cabin:", selection: $newCabin) {
                ForEach(Array(data.c.cabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            Picker("Fanatic:", selection: $newFanatic){
                Text("None").tag("None")
                ForEach(Array(data.c.fanatics.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding(.bottom)
            Text("Skills:")
                .bold()
                .padding(.bottom, 1)
            Group {
                #warning("TODO: change this to be a ForEach")
                Picker("Skill One:", selection: $newSkills[0]){
                    ForEach(Array(data.c.skills.keys).filter({!data.c.fanatics.keys.contains($0)}).sorted(), id: \.self){
                        Text($0).tag($0)
                    }
                }
                .foregroundColor(data.skillIsOverMax(oldSkill: targetCamper.skills[0], newSkill: newSkills[0], skillPeriod: 0) ? Color(.systemRed) : Color.primary)
                .disabled(newFanatic != "None" && data.c.fanatics[newFanatic]?.activePeriods[0] ?? false)
                Picker("Skill Two:", selection: $newSkills[1]){
                    ForEach(Array(data.c.skills.keys).filter({!data.c.fanatics.keys.contains($0)}).sorted(), id: \.self){
                        Text($0).tag($0)
                    }
                }
                .foregroundColor(data.skillIsOverMax(oldSkill: targetCamper.skills[1], newSkill: newSkills[1], skillPeriod: 1) ? Color(.systemRed) : Color.primary)
                .disabled(newFanatic != "None" && data.c.fanatics[newFanatic]?.activePeriods[1] ?? false)
                Picker("Skill Three:", selection: $newSkills[2]){
                    ForEach(Array(data.c.skills.keys).filter({!data.c.fanatics.keys.contains($0)}).sorted(), id: \.self){
                        Text($0).tag($0)
                    }
                }
                .foregroundColor(data.skillIsOverMax(oldSkill: targetCamper.skills[2], newSkill: newSkills[2], skillPeriod: 2) ? Color(.systemRed) : Color.primary)
                .disabled(newFanatic != "None" && data.c.fanatics[newFanatic]?.activePeriods[2] ?? false)
                Picker("Skill Four:", selection: $newSkills[3]){
                    ForEach(Array(data.c.skills.keys).filter({!data.c.fanatics.keys.contains($0)}).sorted(), id: \.self){
                        Text($0).tag($0)
                    }
                }
                .foregroundColor(data.skillIsOverMax(oldSkill: targetCamper.skills[3], newSkill: newSkills[3], skillPeriod: 3) ? Color(.systemRed) : Color.primary)
                .disabled(newFanatic != "None" && data.c.fanatics[newFanatic]?.activePeriods[3] ?? false)
            }
            Text("Preferred Skills:")
                .bold()
                .padding(.top, 8)
            Group {
                #warning("TODO: change this to be a ForEach")
                Picker("First:", selection: $newPreferredSkills[0]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Second:", selection: $newPreferredSkills[1]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Third:", selection: $newPreferredSkills[2]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Fourth:", selection: $newPreferredSkills[3]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                Picker("Fifth:", selection: $newPreferredSkills[4]){
                    ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                        Text($0).tag($0)
                    }
                }
                if(newFanatic == "None"){
                    Picker("Sixth:", selection: $newPreferredSkills[5]){
                        ForEach(Array(data.c.skills.keys).sorted().filter({!data.c.fanatics.keys.contains($0)}), id: \.self){
                            Text($0).tag($0)
                        }
                    }
                } else {
                    Picker("Sixth:", selection: $blank){
                        Text("").tag("")
                    }
                    .disabled(true)
                }
            }
            HStack {
                Spacer()
                Button("Dismiss") {
                    dismiss()
                }
                Button("Save Changes") {
                    data.objectWillChange.send()
                    if(newFanatic != "None"){
                        newPreferredSkills.remove(at: 5)
                    }
                    //still in a fanatic or still NOT in fanatic and preferred skills haven't changed
                    if(targetCamper.preferredSkills == newPreferredSkills){
                        targetCamper.fName = newFirstName
                        targetCamper.lName = newLastName
                        if(targetCamper.cabin != newCabin){
                            data.removeCamperFromCabin(camperID: camperID, usingInternally: true)
                            data.assignCamperToCabin(targetCamper: targetCamper, cabinName: newCabin, usingInternally: true)
                        }
                        if(targetCamper.fanatic != newFanatic){
                            try! data.removeCamperFromFanatic(camperID: camperID, fanaticName: targetCamper.fanatic, newSixthPreferredSkill: "THIS SKILL SHOULDN'T EXIST.", usingInternally: true)
                            try! data.assignCamperToFanatic(targetCamper: targetCamper, fanaticName: newFanatic, usingInternally: true)
                        }
                        for i in 0...3 {
                            if(targetCamper.skills[i] != newSkills[i] && targetCamper.skills[i] != "None" && !data.c.fanatics.keys.contains(targetCamper.skills[i])){
                                try! data.removeCamperFromSkill(camperID: targetCamper.id, skillName: targetCamper.skills[i], period: i, usingInternally: true)
                            }
                            if(targetCamper.skills[i] != newSkills[i] && newSkills[i] != "None" && !data.c.fanatics.keys.contains(targetCamper.skills[i])){
                                data.assignCamperToSkill(targetCamper: targetCamper, skillName: newSkills[i], period: i, usingInternally: true)
                            }
                        }
                        dismiss()
                    //changing fanatic status or preferred skills have changed
                    } else {
                        newPreferredSkills.removeAll(where: {$0 == "None"})
                        if(newPreferredSkills != newPreferredSkills.uniqued()){
                            newPreferredSkills = newPreferredSkills.uniqued()
                            while(newPreferredSkills.count < 6){
                                newPreferredSkills.append("None")
                            }
                            duplicateSkillsAlert.toggle()
                        } else {
                            targetCamper.fName = newFirstName
                            targetCamper.lName = newLastName
                            if(targetCamper.cabin != newCabin){
                                data.removeCamperFromCabin(camperID: camperID, usingInternally: true)
                                data.assignCamperToCabin(targetCamper: targetCamper, cabinName: newCabin, usingInternally: true)
                            }
                            if(newFanatic != "None" && newPreferredSkills.count == 6){
                                newPreferredSkills.remove(at: 5)
                            }
                            while(newPreferredSkills.count < (newFanatic == "None" ? 6 : 5)){
                                newPreferredSkills.append("None")
                            }
                            if(targetCamper.fanatic == "None" && newFanatic != "None"){
                                try! data.assignCamperToFanatic(targetCamper: targetCamper, fanaticName: newFanatic)
                            } else if(targetCamper.fanatic != "None" && newFanatic == "None"){
                                try! data.removeCamperFromFanatic(camperID: camperID, fanaticName: targetCamper.fanatic, newSixthPreferredSkill: "THIS SKILL SHOULDN'T EXIST")
                            } else if(targetCamper.fanatic != newFanatic && targetCamper.fanatic != "None" && newFanatic != "None"){
                                try! data.removeCamperFromFanatic(camperID: camperID, fanaticName: targetCamper.fanatic, newSixthPreferredSkill: "THIS SKILL SHOULDN'T EXIST")
                                try! data.assignCamperToFanatic(targetCamper: targetCamper, fanaticName: newFanatic)
                            }
                            targetCamper.preferredSkills = newPreferredSkills
                            for i in 0...3 {
                                if(targetCamper.skills[i] != newSkills[i] && targetCamper.skills[i] != "None" && !data.c.fanatics.keys.contains(targetCamper.skills[i])){
                                    try! data.removeCamperFromSkill(camperID: targetCamper.id, skillName: targetCamper.skills[i], period: i)
                                }
                                if(targetCamper.skills[i] != newSkills[i] && newSkills[i] != "None" && !data.c.fanatics.keys.contains(targetCamper.skills[i])){
                                    data.assignCamperToSkill(targetCamper: targetCamper, skillName: newSkills[i], period: i)
                                }
                            }
                            dismiss()
                        }
                    }
                    data.undoManager.registerUndo(withTarget: data.c){ _ in
                        #warning("TODO: handle camper info editing")
                    }
                }
                .disabled(try! !data.evaluateFanatics(fanatic: newFanatic, periods: newSkills) || newFirstName == "" || newLastName == "" ||
                          (targetCamper.fName != newFirstName && targetCamper.lName != newLastName && !humanIsUnique(fName: newFirstName, lName: newLastName, humanSet: data.c.campers)))
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .alert(isPresented: $duplicateSkillsAlert) {
                    Alert(title: Text("Error!"),
                          message: Text("Duplicate preferred skills found. All duplicates have been removed."),
                          dismissButton: .default(Text("Dismiss")))
                }
            }
            .padding(.top)
        }
        .padding()
        .frame(width: 300, height: 550)
        .onAppear(perform: {
            targetCamper = data.getCamper(camperID: camperID)!
            newFirstName = targetCamper.fName
            newLastName = targetCamper.lName
            newCabin = targetCamper.cabin
            newFanatic = targetCamper.fanatic
            newSkills = targetCamper.skills
            newPreferredSkills = targetCamper.preferredSkills
            if(targetCamper.fanatic != "None"){
                newPreferredSkills.append("None")
            }
        })
    }
    init(camperID: Camper.ID){
        self.camperID = camperID
    }
}

/*
struct CamperInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CamperInfoView()
    }
}*/
