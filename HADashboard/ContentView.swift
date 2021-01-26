import SwiftUI
import HAClient

struct ContentView: View {
    @EnvironmentObject var registry: Registry
    
    var body: some View {
        List(registry.areas, id: \.id) { area in
            Text(area.name)
//            List(registry.entitiesInArea(areaId: area.id), id: \.id) { entity in
//                Text(entity.id)
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
