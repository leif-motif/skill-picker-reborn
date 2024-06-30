/*
 * ViewOperations.swift
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

import Foundation
import SwiftUI

extension CampData {
    func importFromCSV(){
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.commaSeparatedText]
        if panel.runModal() == .OK {
            do {
                self.csvInput = try String(contentsOf: panel.url!).lines
                self.idiots = try evaluateCamperIdiocyFromCSV(csv: self.csvInput, strict: true)
                self.importSkillList = try skillListFromCSV(csv: self.csvInput)
                self.importSkillDemand = [:]
                for skill in self.importSkillList.keys {
                    if(!self.importSkillList[skill]!){
                        self.importSkillDemand[skill] = try evaluateSkillDemandFromCSV(csv: csvInput, targetSkill: skill)
                    }
                }
                if(idiots.isEmpty){
                    self.importSkillSheet.toggle()
                } else {
                    //This didn't do exactly what I wanted so I renamed things.
                    self.majorIdiots = try evaluateCamperIdiocyFromCSV(csv: csvInput)
                    self.idiots = self.idiots.filter { !majorIdiots.contains($0)}
                    self.ignoreIdiotsConfirm.toggle()
                }
            } catch SPRError.AmbiguousSkillEntries(let s){
                self.genericErrorDesc = "The provided CSV has skills or fanatic options that cannot be evaluated because no camper has selected them. Remove the following skills/fanatics: \(s)"
                self.genericErrorAlert.toggle()
            } catch SPRError.InvalidFileFormat {
                self.genericErrorDesc = "The provided CSV is invalid and cannot be imported."
                self.genericErrorAlert.toggle()
            } catch {
                self.genericErrorDesc = "Failed reading from URL: \(String(describing: panel.url)), Error: " + error.localizedDescription
                self.genericErrorAlert.toggle()
            }
        }
    }
}
