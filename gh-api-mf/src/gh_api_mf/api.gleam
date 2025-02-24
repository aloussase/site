import gleam/dynamic/decode

import lustre/effect
import lustre_http

import gh_api_mf/message
import gh_api_mf/types.{type Issue, Issue}

pub fn fetch_issues(from api_url: String) -> effect.Effect(message.Msg) {
  let decoder = {
    use body <- decode.field("body", decode.string)
    use url <- decode.field("url", decode.string)
    use id <- decode.field("id", decode.int)
    use title <- decode.field("title", decode.string)
    decode.success(Issue(body, id, title, url))
  }

  let expect =
    lustre_http.expect_json(decode.list(decoder), message.ApiIssuesResponse)

  lustre_http.get(api_url, expect)
}
