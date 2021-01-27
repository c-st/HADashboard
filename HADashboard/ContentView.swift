import HAClient
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        HStack {
            List(viewModel.areas, id: \.id) { area in
                Text(area.name)
            }

            List(viewModel.devices, id: \.id) { device in
                Text("Device \(device.id)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
