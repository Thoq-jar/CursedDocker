import Foundation

class Leaky {
    var strongRef: Leaky?

    deinit {
        print("Leaky deinit")
    }
}

func create() {
    DispatchQueue.concurrentPerform(iterations: ProcessInfo.processInfo.processorCount) { index in
        while true {
            var objArray = [Leaky]()
            for _ in 1...100000000000 {
                let obj = Leaky()
                objArray.append(obj)
            }
            for i in 0..<objArray.count {
                objArray[i].strongRef = objArray[(i + 1) % objArray.count]
            }
        }
    }
}

create()
