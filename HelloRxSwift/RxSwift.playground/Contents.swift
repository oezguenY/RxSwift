import UIKit
import RxSwift
import RxCocoa


//let observable = Observable.just(1)

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
    if let element = event.element {
        print(element)
    }
}

// with onNext, we don't have to unwrap values
// when we return a subscription (what we are doing here), we create a subscriber, and that subscriber will always listen or observe the particular sequence unless we remove it from memory
let subscription4 = observable4.subscribe(onNext: { element in
    print(element)
})

subscription4.dispose()


let disposeBag = DisposeBag()

Observable.of("A","B","C")
    .subscribe {
        print($0)
    }.disposed(by: disposeBag)

// You can use this function to create subscriptions as well

Observable<String>.create { observer in

    observer.onNext("A")
    observer.onCompleted()
    // never gets called because of onCompleted
    observer.onNext("?")
    // when the create function is used, a Disposable has to be returned
    return Disposables.create()
}.subscribe(onNext: {print($0)}, onError: {print($0)}, onCompleted: {print("Completed")}, onDisposed: {print("Disposed")})
.disposed(by: disposeBag)


// MARK: - Publish Subject

// with publishSubjects, events only get called after subscription

let subject = PublishSubject<String>()

subject.onNext("Issue 1")
subject.subscribe { event in
    print(event)
}

subject.onNext("Issue 2")
subject.onNext("Issue 3")

// if you create events after disposing, these events will not be called. OnCompleted() won't be called as well after dipose
subject.dispose()

subject.onCompleted()
subject.onNext("Issue 4")


// MARK: - BehaviorSubjects

// In order for behaviorSubjects to initialize we have to pass in an initial value

let behaviorSubject = BehaviorSubject(value: "Initial Value")

// as you test this out, you notice that the last value before, and every value after subscription gets printed

behaviorSubject.onNext("Issue 0")

behaviorSubject.subscribe { event in
    print(event)
}

behaviorSubject.onNext("Issue 1")

behaviorSubject.onNext("Issue 2")

behaviorSubject.onNext("Issue 3")

behaviorSubject.onNext("Issue 4")


// MARK: - ReplaySubject

// A replaySubject replays events based on the bufferSize that you set

// a replaySubject replays the last x events you put into the buffersize, before subscribing. It also creates all those events created after subscription
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("Issue A")
replaySubject.onNext("Issue A")
replaySubject.onNext("Issue B")
replaySubject.subscribe {
    print($0)
}

replaySubject.onNext("Issue A")
replaySubject.onNext("Issue B")
replaySubject.onNext("Issue C")


// notice, how this rule is individually applicable to every subscription

print("[Subscription 2]")
replaySubject.subscribe {
    print($0)
}




// MARK: - BehaviorRelays

let relay = BehaviorRelay(value: "Initial Value")

relay.asObservable()
    .subscribe {
        print($0)
    }
// you cant change the value of behaviorRelays. Though, you can create new values. Reason being, the value of behaviorRelays are just read only

// Not possible
//relay.value = "blah"
//
// get a new value
//relay.accept("Hello World")


let relay2 = BehaviorRelay(value: ["Item 1"])

var value = relay2.value
value.append("Item 2")
value.append("Item 3")

relay2.accept(value)

relay2.asObservable()
    .subscribe {
        print($0)
    }


