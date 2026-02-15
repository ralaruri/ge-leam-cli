import gleam/httpc
import gleam/http/request
import gleam/json
import gleam/dynamic.{type Dynamic}
import gleam/dict
import gleam/int
import ge/types.{type Item, type Price, Item, Price}

const base_url = "https://prices.runescape.wiki/api/v1/osrs"

const user_agent = "ge-gleam-cli"

pub fn fetch_mapping() -> Result(List(Item), String) {
  let assert Ok(req) = request.to(base_url <> "/mapping")
  let req = request.set_header(req, "user-agent", user_agent)

  case httpc.send(req) {
    Ok(resp) -> {
      case json.decode(from: resp.body, using: dynamic.list(item_decoder())) {
        Ok(items) -> Ok(items)
        Error(_) -> Error("Failed to decode mapping response")
      }
    }
    Error(_) -> Error("Failed to fetch mapping")
  }
}

pub fn fetch_latest(item_id: Int) -> Result(Price, String) {
  let url = base_url <> "/latest?id=" <> int.to_string(item_id)
  let assert Ok(req) = request.to(url)
  let req = request.set_header(req, "user-agent", user_agent)

  case httpc.send(req) {
    Ok(resp) -> {
      let decoder =
        dynamic.field(
          "data",
          dynamic.dict(dynamic.string, price_decoder()),
        )
      case json.decode(from: resp.body, using: decoder) {
        Ok(data) -> {
          case dict.get(data, int.to_string(item_id)) {
            Ok(price) -> Ok(price)
            Error(_) -> Error("Item not found in response")
          }
        }
        Error(_) -> Error("Failed to decode price response")
      }
    }
    Error(_) -> Error("Failed to fetch latest prices")
  }
}

fn item_decoder() -> fn(Dynamic) -> Result(Item, List(dynamic.DecodeError)) {
  dynamic.decode5(
    Item,
    dynamic.field("id", dynamic.int),
    dynamic.field("name", dynamic.string),
    dynamic.field("members", dynamic.bool),
    dynamic.optional_field("highalch", dynamic.int),
    dynamic.optional_field("limit", dynamic.int),
  )
}

fn price_decoder() -> fn(Dynamic) -> Result(Price, List(dynamic.DecodeError)) {
  dynamic.decode4(
    Price,
    dynamic.optional_field("high", dynamic.int),
    dynamic.optional_field("highTime", dynamic.int),
    dynamic.optional_field("low", dynamic.int),
    dynamic.optional_field("lowTime", dynamic.int),
  )
}
