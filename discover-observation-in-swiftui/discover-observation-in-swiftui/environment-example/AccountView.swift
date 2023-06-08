//
//  AccountView.swift
//  discover-observation-in-swiftui
//
//  Created by Huang Runhua on 6/8/23.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(Account.self) var account
    
    var body: some View {
        if !(account.userName == "") {
            HStack {
                Text(account.userName)
                Button("Log out") {
                    print(account.userName)
                    account.userName = ""
                }
            }
        } else {
            Button("Login") {
                account.userName = "Joker Hook"
            }
        }
    }
}

#Preview {
    AccountView()
        // Also need this.
        .environment(Account())
}
