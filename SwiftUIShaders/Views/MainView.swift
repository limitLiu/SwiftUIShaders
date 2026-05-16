import SwiftUI

enum AppRoute: Hashable {
  case moon
  case algorithmicDrawing
}

extension AppRoute: CustomStringConvertible {
  var description: String {
    switch self {
    case .moon: "Moon"
    case .algorithmicDrawing: "Algorithmic Drawing"
    }
  }
}

struct MainView: View {
  let data: [AppRoute] = [.moon, .algorithmicDrawing]

  var body: some View {
    NavigationStack {
      List(data, id: \.self) { it in
        NavigationLink(value: it) {
          Text(it.description).padding()
        }
      }
      .navigationDestination(for: AppRoute.self) {
        switch $0 {
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
