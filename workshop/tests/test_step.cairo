use super::utils::deploy_contract;
use snforge_std::{load, map_entry_address};

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
