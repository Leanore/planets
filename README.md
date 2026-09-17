# Planets - Interplanetary Travel Fuel Calculator

The application lets a user build a travel path between 3 supported space destinations - select a planet, then Launch or Land to build the travel path.
The total fuel needed for this travel is calculated based on the equipment mass and the travel path.

## Setup

* Run `mix deps.get` then `mix assets.setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server`
* Run `mix test` to run the test suite
* Run `mix precommit` for checks and tests

Once the Phoenix endpoint is up and running you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Design decisions

The usage of the database was omitted for simplicity.

Took a deliberate decision to limit UI capabilities of travel path building for logical reasons.
For example, it's impossible to launch the ship off Mars once it was landed on Moon.

Regarding live updates to the travel path - it's possible to add a step, remove the last step, or clear the whole travel path, but it's not possible to remove a step from the middle, since that could leave the rest of the path inconsistent (e.g. a landing with no matching launch before it) and complicate the whole logic.
