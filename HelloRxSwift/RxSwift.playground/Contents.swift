import UIKit
import RxSwift

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
