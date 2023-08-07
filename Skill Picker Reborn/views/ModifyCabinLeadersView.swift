//
//  ModifyCabinLeadersView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import SwiftUI

struct ModifyCabinLeadersView: View {
    @EnvironmentObject private var data: CampData
    @State private var seniorSelection = nullSenior.id
    @State private var juniorSelection = nullJunior.id
    private var targetCabin: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Picker("Senior", selection: $seniorSelection) {
                Text("None").tag(nullSenior.id)
                if(data.leaders.count > 0){
                    ForEach(0...(data.leaders.count-1), id: \.self){
                        if(data.leaders[$0].senior){
                            Text(data.leaders[$0].fName+" "+data.leaders[$0].lName).tag(data.leaders[$0].id)
                        }
                    }
                }
            }
            .padding([.top,.horizontal])
            Picker("Junior", selection: $juniorSelection) {
                Text("None").tag(nullJunior.id)
                if(data.leaders.count > 0){
                    ForEach(0...(data.leaders.count-1), id: \.self){
                        if(!data.leaders[$0].senior){
                            Text(data.leaders[$0].fName+" "+data.leaders[$0].lName).tag(data.leaders[$0].id)
                        }
                    }
                }
            }
            .padding([.bottom,.horizontal])
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Change Cabin Leaders") {
                    if(seniorSelection == nullSenior.id && juniorSelection == nullJunior.id){
                        changeCabinLeaders(cabinName: targetCabin, targetSenior: nullSenior, targetJunior: nullJunior, data: data)
                    } else if(seniorSelection == nullSenior.id){
                        changeCabinLeaders(cabinName: targetCabin,
                                           targetSenior: nullSenior,
                                           targetJunior: data.leaders.first(where: {$0.id == juniorSelection})!, data: data)
                    } else if(juniorSelection == nullJunior.id){
                        changeCabinLeaders(cabinName: targetCabin,
                                           targetSenior: data.leaders.first(where: {$0.id == seniorSelection})!,
                                           targetJunior: nullJunior, data: data)
                    } else {
                        changeCabinLeaders(cabinName: targetCabin,
                                           targetSenior: data.leaders.first(where: {$0.id == seniorSelection})!,
                                           targetJunior: data.leaders.first(where: {$0.id == juniorSelection})!, data: data)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding([.bottom,.trailing])
        }
        .frame(width: 310, height: 120)
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
