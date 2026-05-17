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
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  private let data: [AppRoute] = [.helloWorld, .moon, .algorithmicDrawing]
  @State private var selection: AppRoute?

  var body: some View {
    NavigationSplitView {
      List(data, selection: $selection) { route in
        NavigationLink(value: route) {
          Text(route.description)
        }
      }
      .navigationTitle("Shaders Playground")
    } detail: {
      if let selection {
        detailView(for: selection)
          .navigationTitle(selection.description)
          .navigationBarTitleDisplayMode(.inline)
      } else {
        ContentUnavailableView(
          "Select a Shader",
          systemImage: "sparkles",
          description: Text("Choose an effect from the sidebar.")
        )
      }
    }
    .onAppear {
      updateDefaultSelection()
    }
    .onChange(of: horizontalSizeClass) {
      updateDefaultSelection()
    }
  }

  @ViewBuilder
  private func detailView(for route: AppRoute) -> some View {
    switch route {
    case .helloWorld: HelloWorld()
    case .moon: MoonView()
    case .algorithmicDrawing: AlgorithmicDrawingView()
    }
  }

  private func updateDefaultSelection() {
    guard horizontalSizeClass == .regular, selection == nil else {
      return
    }
    selection = .helloWorld
  }
}

extension AppRoute: Identifiable {
  var id: Self { self }
}

#Preview {
  MainView()
}
