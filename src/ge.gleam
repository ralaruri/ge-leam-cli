import gleam/io
import gleam/string
import gleam/list
import argv
import ge/api
import ge/display
import ge/types

pub fn main() {
  case argv.load().arguments {
    ["price", ..name_parts] -> {
      let name = string.join(name_parts, " ")
      price_command(name)
    }
    ["search", ..query_parts] -> {
      let query = string.join(query_parts, " ")
      search_command(query)
    }
    _ -> io.println("Usage:\n  ge price <item_name>\n  ge search <query>")
  }
}

fn price_command(name: String) -> Nil {
  case api.fetch_mapping() {
    Ok(items) -> {
      let lower_name = string.lowercase(name)
      let matches =
        list.filter(items, fn(item: types.Item) {
          string.lowercase(item.name) == lower_name
        })
      case matches {
        [item, ..] -> {
          case api.fetch_latest(item.id) {
            Ok(price) -> io.println(display.format_item_price(item, price))
            Error(err) -> io.println("Error: " <> err)
          }
        }
        [] -> io.println("No item found with name \"" <> name <> "\"")
      }
    }
    Error(err) -> io.println("Error: " <> err)
  }
}

fn search_command(query: String) -> Nil {
  case api.fetch_mapping() {
    Ok(items) -> {
      let lower_query = string.lowercase(query)
      let matches =
        list.filter(items, fn(item: types.Item) {
          string.contains(string.lowercase(item.name), lower_query)
        })
      case matches {
        [] -> io.println("No items found matching \"" <> query <> "\"")
        _ -> io.println(display.format_search_results(matches, query))
      }
    }
    Error(err) -> io.println("Error: " <> err)
  }
}
