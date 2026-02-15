import gleam/option.{type Option}

pub type Item {
  Item(
    id: Int,
    name: String,
    members: Bool,
    highalch: Option(Int),
    limit: Option(Int),
  )
}

pub type Price {
  Price(
    high: Option(Int),
    high_time: Option(Int),
    low: Option(Int),
    low_time: Option(Int),
  )
}
