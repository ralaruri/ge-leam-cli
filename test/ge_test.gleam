import gleeunit
import gleeunit/should
import gleam/option.{Some}
import gleam/string
import ge/display
import ge/types.{Item, Price}

pub fn main() {
  gleeunit.main()
}

pub fn format_number_test() {
  display.format_number(0) |> should.equal("0")
  display.format_number(100) |> should.equal("100")
  display.format_number(999) |> should.equal("999")
  display.format_number(1000) |> should.equal("1,000")
  display.format_number(1_350_000) |> should.equal("1,350,000")
  display.format_number(1_000_000) |> should.equal("1,000,000")
}

pub fn format_search_results_test() {
  let items = [
    Item(
      id: 4587,
      name: "Dragon scimitar",
      members: True,
      highalch: Some(100_000),
      limit: Some(70),
    ),
    Item(
      id: 1305,
      name: "Dragon longsword",
      members: True,
      highalch: Some(60_000),
      limit: Some(70),
    ),
  ]
  let result = display.format_search_results(items, "dragon")
  result |> string.contains("Found 2 items") |> should.be_true
  result |> string.contains("Dragon scimitar") |> should.be_true
  result |> string.contains("Dragon longsword") |> should.be_true
}

pub fn format_item_price_test() {
  let item =
    Item(
      id: 4151,
      name: "Abyssal whip",
      members: True,
      highalch: Some(72_000),
      limit: Some(70),
    )
  let price =
    Price(
      high: Some(1_350_000),
      high_time: Some(0),
      low: Some(1_340_000),
      low_time: Some(0),
    )
  let result = display.format_item_price(item, price)
  result |> string.contains("Abyssal whip") |> should.be_true
  result |> string.contains("1,350,000 gp") |> should.be_true
  result |> string.contains("1,340,000 gp") |> should.be_true
  result |> string.contains("Members:    Yes") |> should.be_true
}
