use super::utils::deploy_contract;
use snforge_std::{load, map_entry_address};
use snforge_std::{
    spy_events, EventSpy, EventSpyAssertionsTrait,
    EventSpyTrait, // Add for fetching events directly  
     Event,
};


#[test]
fn check_stored_counter() {
    let initial_counter = 12;

    let contract_address = deploy_contract(initial_counter);

    let loaded = load(contract_address, selector!("counter"), 1);

    assert!(*loaded.at(0) == initial_counter.into(), "Stored value not equal");
}

use workshop::counter::{ICounterContractDispatcher, ICounterContractDispatcherTrait};

#[test]
fn check_stored_counter1() {
    let initial_counter = 12;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterContractDispatcher { contract_address };
    let stored_counter = dispatcher.get_counter();
    assert!(stored_counter == initial_counter, "Stored value not equal");
}


#[test]
fn check_increase_counter() {
    let initial_counter = 15;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterContractDispatcher { contract_address };

    dispatcher.increase_counter(2);
    let stored_counter = dispatcher.get_counter();
    assert!(stored_counter == initial_counter + 2, "Stored value not equal");
}


#[test]
fn test_counter_event() {
    let initial_counter = 15;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterContractDispatcher { contract_address };

    let mut spy = spy_events();
    dispatcher.increase_counter(12);
    let events = spy.get_events(); // Ad 2.

    assert(events.events.len() == 1, 'There should be one event');
    let (from, event) = events.events.at(0); // Ad 3.
    assert(from == @contract_address, 'Emitted from wrong address');
    assert(event.keys.len() == 1, 'There should be one key');
    assert(event.keys.at(0) == @selector!("CounterIncreased"), 'Wrong event name');
}
