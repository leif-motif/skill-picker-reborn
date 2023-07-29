//
//  ModifyCabinLeadersView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import SwiftUI

struct ModifyCabinLeadersView: View {
    @State private var seniorSelection = "None"
    @State private var juniorSelection = "None"
    private var targetCabin: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Senior", selection: $seniorSelection) {
                Text("None").tag("None")
                ForEach(zip(fooLeaders.filter{$0.senior}.map(\.fName),fooLeaders.filter{$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding([.top,.horizontal])
            Picker("Junior", selection: $juniorSelection) {
                Text("None").tag("None")
                ForEach(zip(fooLeaders.filter{!$0.senior}.map(\.fName),fooLeaders.filter{!$0.senior}.map(\.lName)).map {$0+" "+$1}, id: \.self){
                    Text($0).tag($0)
                }
            }
            .padding([.bottom,.horizontal])
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Change Cabin Leaders") {
                    if(seniorSelection == "None" && juniorSelection == "None"){
                        changeCabinLeaders(cabinName: targetCabin, targetSenior: nullSenior, targetJunior: nullJunior)
                    } else if(seniorSelection == "None"){
                        changeCabinLeaders(cabinName: targetCabin,
                                    targetSenior: nullSenior,
                                    targetJunior: fooLeaders.first(where: {$0.fName == juniorSelection.components(separatedBy: " ")[0] && $0.lName == juniorSelection.components(separatedBy: " ")[1]})!)
                    } else if(juniorSelection == "None"){
                        changeCabinLeaders(cabinName: targetCabin,
                                    targetSenior: fooLeaders.first(where: {$0.fName == seniorSelection.components(separatedBy: " ")[0] && $0.lName == seniorSelection.components(separatedBy: " ")[1]})!,
                                    targetJunior: nullJunior)
                    } else {
                        changeCabinLeaders(cabinName: targetCabin,
                                    targetSenior: fooLeaders.first(where: {$0.fName == seniorSelection.components(separatedBy: " ")[0] && $0.lName == seniorSelection.components(separatedBy: " ")[1]})!,
                                    targetJunior: fooLeaders.first(where: {$0.fName == juniorSelection.components(separatedBy: " ")[0] && $0.lName == juniorSelection.components(separatedBy: " ")[1]})!)
                    }
                    dismiss()
                }
            }
            .padding([.bottom,.trailing])
        }
    }
    init(targetCabin: String) {
        self.targetCabin = targetCabin
    }
}

struct ModifyCabinLeadersView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyCabinLeadersView(targetCabin: "This is a cabin.")
    }
}
