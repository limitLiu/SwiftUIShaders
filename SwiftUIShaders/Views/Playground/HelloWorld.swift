import SwiftUI

struct HelloWorld: View {
  @State private var start = Date()

  var body: some View {
    HStack {
      Rectangle()
        .colorEffect(ShaderLibrary.helloWorld())
      
      TimelineView(.animation) { timeline in
        Rectangle()
          .colorEffect(ShaderLibrary.sinTime(.float(timeline.date.timeIntervalSince(start))))
      }
      
      GeometryReader { proxy in
        Rectangle()
          .colorEffect(ShaderLibrary.coord(.float2(proxy.size)))
      }
    }
    .ignoresSafeArea()
  }
}
