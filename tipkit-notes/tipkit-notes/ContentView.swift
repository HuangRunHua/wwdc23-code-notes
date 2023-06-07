//
//  ContentView.swift
//  tipkit-notes
//
//  Created by Huang Runhua on 6/7/23.
//

import SwiftUI
import TipKit

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            articleView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {} label: { Image(systemName: "chevron.backward") }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {} label: { Image(systemName: "textformat.size") }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {} label: { Image(systemName: "bookmark") }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {} label: { Image(systemName: "square.and.arrow.up") }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}

// MARK: Tips define here.
struct bookmarkTip: Tip {
    
}

extension ContentView {
    var articleView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text("Espresso")
                        .font(Font.custom("Georgia", size: 17))
                        .foregroundStyle(.blue)
                    Spacer()
                }
                HStack {
                    Text("The world in brief")
                        .font(Font.custom("Georgia", size: 30))
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
            .padding()
            
            HStack {
                Text("Ukrainian officials estimated that about 42,000 people are at risk from the flooding triggered by explosions at the Kakhovka dam in a Russian-controlled area of southern Ukraine. The UN Security Council held an emergency meeting, during which Russia and Ukraine blamed each other for the blasts. America, Britain and France called for an investigation. Martin Griffiths, the UN’s aid chief, warned that the “sheer magnitude of the catastrophe” will be only realised in the coming days.")
                    .font(Font.custom("Georgia", size: CGFloat(17)))
                    .lineSpacing(7)
                Spacer()
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 12)
            
            HStack {
                Text("China’s exports slumped in May, fuelling fears that the country’s post-covid recovery might falter. In the face of weak global demand, exports fell by 7.5% compared with the same month last year; economists had predicted a less-than-1% drop. Imports fell by 4.5% over the same period, although that was better than forecast.")
                    .font(Font.custom("Georgia", size: CGFloat(17)))
                    .lineSpacing(7)
                Spacer()
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 12)
            
            HStack {
                Text("The EU is reportedly considering banning companies that might pose a security risk to states’ 5G networks, including Huawei, a Chinese firm. According to the Financial Times, EU officials believe countries are not doing enough to address such threats. Only a third of the bloc’s members have banned Huawei from the core parts of their 5G networks, as the EU has recommended.")
                    .font(Font.custom("Georgia", size: CGFloat(17)))
                    .lineSpacing(7)
                Spacer()
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 12)
            
            HStack {
                Text("Smoke from wildfires in Canada engulfed large parts of north-east America, including New York. Environmental agencies in both countries issued warnings about air quality. Pollution levels in New York were among the worst in the world on Tuesday night, according to IQAir, a pollution-tracking firm. Canada’s forest-fire agency said there are more than 400 wildfires currently burning in the country.")
                    .font(Font.custom("Georgia", size: CGFloat(17)))
                    .lineSpacing(7)
                Spacer()
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 12)
            
            HStack {
                Text("Sequoia Capital, an American venture-capital giant, announced that it would split off its Chinese business into a separate company. The firm became one of the most successful American-Chinese investing alliances by betting on Chinese tech companies such as Alibaba, but rising political tension between the two countries has made it increasingly difficult to do business. Sequoia’s Indian and South-East Asian arm will also become a new entity.")
                    .font(Font.custom("Georgia", size: CGFloat(17)))
                    .lineSpacing(7)
                Spacer()
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 12)

        }
    }
}
