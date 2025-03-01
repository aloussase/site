pub type Issue {
  Issue(
    body: String,
    id: Int,
    title: String,
    url: String,
    repository: String,
    labels: List(String),
  )
}
