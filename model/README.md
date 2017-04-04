# The model of the drum_sequencer.

This packages follows Dart's package conventions, but it can also be explained with some popular "Architecture Pattern" terms.

#### src/drum_sequencer.dart

The Drum Sequencer. The only interface of this package except DI providers.

This might be a sort of "Context" in DCI notion without ad-hoc role injections, delegations, interactions in my mind.

This can also be called as "UseCase" in Clean Architecture, and "Application Layer" or "Application Service" in DDD-like idea (not strictly obeys).


### src/drum_sequencer/

A domain layer. This is the only domain directory of this package.


### src/repository/

Corresponding to "Infrastructure Layer" of "Clean Architecture".


# How to run test.

    pub serve --port=8081
    pub run test --pub-serve=8081 -p content-shell