import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/string
import lustre
import lustre/attribute as attr
import lustre/effect
import lustre/element
import lustre/element/html
import lustre/event

import gh_api_mf/api
import gh_api_mf/message.{type Msg}
import gh_api_mf/types.{type Issue}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

pub type Model {
  Model(issues: List(Issue), current_issue: Option(Issue), search: String)
  ErrModel
}

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  let api_url = "https://issuesapi.frustrated-functor.dev/api/issues"
  // let api_url = "http://localhost:3000/api/issues"
  #(
    Model(issues: [], current_issue: option.None, search: ""),
    api.fetch_issues(api_url),
  )
}

pub fn update(model: Model, msg: Msg) -> #(Model, effect.Effect(Msg)) {
  case msg, model {
    message.UpdateSearch(query), Model(..) as model -> #(
      Model(..model, search: query),
      effect.none(),
    )
    message.ShowIssueBody(issue), Model(..) as model -> #(
      Model(..model, current_issue: option.Some(issue)),
      effect.none(),
    )
    message.ClearIssueBody, Model(..) as model -> #(
      Model(..model, current_issue: option.None),
      effect.none(),
    )
    message.ApiIssuesResponse(Ok(issues)), Model(..) as model -> #(
      Model(..model, issues:),
      effect.none(),
    )
    message.ApiIssuesResponse(Error(_)), _ -> #(ErrModel, effect.none())
    _, _ -> #(model, effect.none())
  }
}

pub fn view(model: Model) -> element.Element(Msg) {
  html.div([attr.class("md:w-[60%] mx-auto py-[2rem]")], [
    html.h1([attr.class("text-2xl font-bold text-center md:mb-[20px]")], [
      html.text("Issue Aggregator"),
    ]),
    html.p([attr.class("md:mb-[20px]")], [
      html.text(
        string.concat([
          "Here you can see a list of issues opened across my repositories.",
          " This is mainly for my personal organization, but if you find anything",
          " that interests you, feel free to take a look!",
        ]),
      ),
    ]),
    view_search_bar(model),
    view_error_message(model),
    view_issues_list(model),
  ])
}

fn view_search_bar(_model: Model) -> element.Element(Msg) {
  html.input([
    attr.type_("text"),
    attr.class("border rounded-md p-2 md:mb-[5px] w-full"),
    attr.placeholder("Filter issues by title..."),
    event.on_input(message.UpdateSearch),
  ])
}

fn view_issues_list(model: Model) -> element.Element(Msg) {
  case model {
    Model(issues:, ..) ->
      html.div(
        [attr.class("grid grid-cols-3 gap-2")],
        issues
          |> list.filter(fn(issue) {
            case model.search {
              "" -> True
              s ->
                issue.title
                |> string.lowercase
                |> string.contains(s |> string.lowercase)
            }
          })
          |> list.map(fn(issue) { view_issue(model, issue) }),
      )
    _ -> html.span([], [])
  }
}

fn view_issue(model: Model, issue: Issue) -> element.Element(Msg) {
  html.div(
    [
      attr.class(
        "flex flex-col justify-between gap-2 rounded-md p-3 bg-[#f66b6c] text-[#2e0000] shadow-[4px_4px_0_0_#000] hover:shadow-none hover:translate-[4px]",
      ),
      event.on_mouse_enter(message.ShowIssueBody(issue)),
      event.on_mouse_leave(message.ClearIssueBody),
    ],
    [
      html.small([], [html.text(issue.repository)]),
      view_issue_labels(issue),
      html.span([attr.class("font-bold")], [
        html.text("#" <> issue.id |> int.to_string() <> " " <> issue.title),
      ]),
      view_issue_body(model, issue),
      html.a(
        [
          attr.href(issue.url),
          attr.target("_blank"),
          attr.class(
            "text-[#2e0000] shadow-[4px_4px_0_0_#000] border border-black w-fit rounded self-end",
          ),
        ],
        [html.text("See on GitHub")],
      ),
    ],
  )
}

fn view_issue_labels(issue: Issue) -> element.Element(Msg) {
  html.div(
    [attr.class("flex gap-2")],
    issue.labels
      |> list.map(fn(label) {
        html.span(
          [attr.class("bg-[#2e0000] text-[#fdfeff] rounded-md p-1 text-xs")],
          [html.text(label)],
        )
      }),
  )
}

fn view_issue_body(model: Model, loop_issue: Issue) -> element.Element(Msg) {
  // TODO: Make the API return the actual issue ID.
  case model {
    Model(current_issue: option.Some(issue), ..)
      if issue.id == loop_issue.id && issue.repository == loop_issue.repository
    -> html.div([attr.id(issue.id |> int.to_string)], [html.text(issue.body)])
    _ -> html.span([], [])
  }
}

fn view_error_message(model: Model) -> element.Element(Msg) {
  case model {
    ErrModel ->
      html.div([], [
        html.text("There was an error while fetching the issues list."),
      ])
    _ -> html.span([], [])
  }
}
