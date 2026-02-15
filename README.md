# ge

A command-line tool for checking Old School RuneScape Grand Exchange prices in real time. It pulls live buy/sell prices from the OSRS Wiki API so you can look up any item by name or search for items matching a keyword. Built with Gleam and runs on the Erlang VM.

## Installation

Make sure you have [Gleam](https://gleam.run) (v1.0+) and Erlang/OTP installed, then clone this repo and build:

```sh
git clone https://github.com/ralaruri/gleam-cli.git
cd gleam-cli
gleam build
```

## Usage

```sh
# Look up an item's latest GE price
gleam run -- price "abyssal whip"

# Search for items matching a query
gleam run -- search dragon
```

## Example Output

```
$ ge price "abyssal whip"
Abyssal whip (ID: 4151)
  Buy price:  1,350,000 gp
  Sell price: 1,340,000 gp
  GE limit:   70
  Members:    Yes

$ ge search dragon
Found 191 items matching "dragon":
  Dragon scimitar (ID: 4587)
  Dragon longsword (ID: 1305)
  ...
```

## Development

```sh
gleam build  # Build the project
gleam run    # Run the project
gleam test   # Run the tests
```
