import Foundation
import Combine
import HAClient

class ViewModel: ObservableObject {
    private var cancellableSet: Set<AnyCancellable> = []

    @Published var areas: [Area] = []
    @Published var devices: [Device] = []

    init(_ registry: Registry) {
        registry.allAreas
            .receive(on: RunLoop.main)
            .assign(to: \.areas, on: self)
            .store(in: &cancellableSet)

        registry.allDevices
            .receive(on: RunLoop.main)
            .map { Array($0.values) }
            .assign(to: \.devices, on: self)
            .store(in: &cancellableSet)
    }
}
