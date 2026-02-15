import gleam/int
import gleam/string
import gleam/list
import gleam/option.{None, Some}
import ge/types.{type Item, type Price}

pub fn format_item_price(item: Item, price: Price) -> String {
  let members_str = case item.members {
    True -> "Yes"
    False -> "No"
  }
  let limit_str = case item.limit {
    Some(l) -> format_number(l)
    None -> "N/A"
  }
  let buy_str = case price.high {
    Some(h) -> format_number(h) <> " gp"
    None -> "N/A"
  }
  let sell_str = case price.low {
    Some(l) -> format_number(l) <> " gp"
    None -> "N/A"
  }

  item.name
  <> " (ID: "
  <> int.to_string(item.id)
  <> ")\n"
  <> "  Buy price:  "
  <> buy_str
  <> "\n"
  <> "  Sell price: "
  <> sell_str
  <> "\n"
  <> "  GE limit:   "
  <> limit_str
  <> "\n"
  <> "  Members:    "
  <> members_str
}

pub fn format_search_results(items: List(Item), query: String) -> String {
  let count = list.length(items)
  let header =
    "Found "
    <> int.to_string(count)
    <> " items matching \""
    <> query
    <> "\":\n"
  let entries =
    list.map(items, fn(item) {
      "  " <> item.name <> " (ID: " <> int.to_string(item.id) <> ")"
    })
  header <> string.join(entries, "\n")
}

pub fn format_number(n: Int) -> String {
  case n < 0 {
    True -> "-" <> format_number(-n)
    False -> {
      let digits = int.to_string(n)
      let len = string.length(digits)
      case len <= 3 {
        True -> digits
        False -> insert_commas(digits, len)
      }
    }
  }
}

fn insert_commas(digits: String, len: Int) -> String {
  let first_group = len % 3
  let chars = string.to_graphemes(digits)
  case first_group {
    0 -> group_digits(chars, [])
    _ -> {
      let #(first, rest) = list.split(chars, first_group)
      let first_str = string.concat(first)
      case rest {
        [] -> first_str
        _ -> first_str <> "," <> group_digits(rest, [])
      }
    }
  }
}

fn group_digits(chars: List(String), acc: List(String)) -> String {
  case chars {
    [] -> string.join(list.reverse(acc), ",")
    _ -> {
      let #(group, rest) = list.split(chars, 3)
      let group_str = string.concat(group)
      group_digits(rest, [group_str, ..acc])
    }
  }
}
