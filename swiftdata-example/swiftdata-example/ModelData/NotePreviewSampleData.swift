//
//  NotePreviewSampleData.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/17/23.
//

import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Note.self, ModelConfiguration(inMemory: true)
        )
        for note in SampleNotes.contents {
            container.mainContext.insert(object: note)
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

struct SampleNotes {
    static var contents: [Note] = [
        Note(title: "How Britain can become an AI superpower",
             subtitle: "Rishi Sunak’s enthusiasm is welcome. But his plans for Britain fall short",
             content: "Get ready for some big British celebrations in 2030. By then, if Rishi Sunak is to be believed, the country will be “a science and technology superpower”. The prime minister’s aim is for Britain to prosper from the booming opportunities offered by supercomputing and artificial intelligence. Generative ai has stoked a frenzy of excitement (and some fear) among techies and investors; now politicians have started to acclaim its potential, and British ones are in the vanguard. Britain, says Mr Sunak, will harness ai and thus spur productivity, economic growth and more. As he told an audience in London this week, he sees the “extraordinary potential of ai to improve people’s lives”."),
        Note(title: "Is the global housing slump over?",
             subtitle: "Why rising interest rates have not yet triggered property pandemonium",
             content: "In australia house prices have risen for the past three months. In America a widely watched index of housing values has risen by 1.6% from its low in January, and housebuilders’ share prices have done twice as well as the overall stockmarket. In the euro area the property market looks steady. “[M]ost of the drag from housing on gdp growth from now on should be marginal,” wrote analysts at jpmorgan Chase, a bank, in a recent report about America. “[W]e believe the peak negative drag from the recent housing-market slump to private consumption is likely behind us,” wrote wonks at Goldman Sachs, another bank, about South Korea."),
        Note(title: "How long will the travel boom last?",
             subtitle: "Will demand for sunny getaways wane with economic turbulence?",
             content: "Revenge holidays are in full swing and the travel industry is cashing in. After a rocky few years, the urge to splurge on airline tickets and hotels is set to bring in bumper earnings. Tour operators are inundated with bookings; hotel chains are raking in record profits. EasyJet has raised its earnings forecasts twice this year; iag and Ryanair have both returned to profit for the first time since the start of the pandemic, and Singapore Airlines is handing out some of its record profits as bonuses worth eight months’ salary. With air fares rising faster than inflation, global airline bosses now expect $9.8bn in net income this year, more than double the amount initially forecast, according to the International Air Transport Association, an industry body.")
    ]
}




