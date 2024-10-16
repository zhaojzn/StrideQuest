//
//  StrideTabView.swift
//  StrideApp
//
//  Created by Jason Zhao on 2024-10-15.
//

import SwiftUI

struct StrideTabView: View {
    @State var selectedTab = "Home"
    
    
    init(){
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .green
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.green]
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab){
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            HistoricDataView()
                .tag("History")
                .tabItem {
                    Image(systemName: "chart.bar.doc.horizontal.fill")
                    Text("History")
                }
            LoginView()
                .tag("Login")
                .tabItem {
                    Image(systemName: "person.crop.circle.badge")
                    Text("Login")
                }
        }
    }
}

#Preview {
    StrideTabView()
}
