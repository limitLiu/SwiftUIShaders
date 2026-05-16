import SwiftUI

struct MoonView: View {
  @Environment(\.colorScheme) private var colorScheme
  @State private var startDate = Date()

  var body: some View {
    GeometryReader { proxy in
      let side = min(proxy.size.width, proxy.size.height)
      let moon = UIImage.Textures.moon

      TimelineView(.animation) { timeline in
        let time = Float(timeline.date.timeIntervalSince(startDate))

        Rectangle()
          .fill(.white)
          .frame(width: side, height: side)
          .colorEffect(
            ShaderLibrary.moon(
              .float2(Float(side), Float(side)),
              .image(moon.ex.img),
              .float2(Float(moon.size.width), Float(moon.size.height)),
              .float(time),
              .float(colorScheme == .dark ? 1 : 0)
            )
          )
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .ignoresSafeArea()
  }
}
