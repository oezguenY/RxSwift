import UIKit
import RxSwift

let observable = Observable.just(1)

let observable2 = Observable.of(1,2,3)
// of takes whole array ( if put in )
let observable3 = Observable.of([1,2,3])
// from takes individual values of the array
let observable4 = Observable.from([1,2,3,4,5])

observable4.subscribe { event in
    if let element = event.element {
        print(element)
    }
}

observable3.subscribe { event in
    print(event)
}
