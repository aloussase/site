import lustre_http

import gh_api_mf/types.{type Issue}

pub type Msg {
  ShowIssueBody(Issue)
  ClearIssueBody
  UpdateSearch(String)
  ApiIssuesResponse(Result(List(Issue), lustre_http.HttpError))
}
