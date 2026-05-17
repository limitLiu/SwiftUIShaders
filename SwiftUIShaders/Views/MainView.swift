import SwiftUI

enum AppRoute: Hashable {
  case helloWorld
  case moon
  case algorithmicDrawing
}

extension AppRoute: CustomStringConvertible {
  var description: String {
    switch self {
    case .helloWorld: "Hello World"
    case .moon: "Moon"
    case .algorithmicDrawing: "Algorithmic Drawing"
    }
  }
}

struct MainView: View {
  let data: [AppRoute] = [.helloWorld, .moon, .algorithmicDrawing]

  var body: some View {
    NavigationStack {
      List(data, id: \.self) { it in
        NavigationLink(value: it) {
          Text(it.description).padding()
        }
      }
      .navigationTitle("Shaders Playground")
      .navigationDestination(for: AppRoute.self) {
        switch $0 {
        case .helloWorld: HelloWorld()
        case .moon: MoonView()
        case .algorithmicDrawing: AlgorithmicDrawingView()
        }
      }
    }
  }
}

#Preview {
  MainView()
}
