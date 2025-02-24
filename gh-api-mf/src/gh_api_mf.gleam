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
  // TODO: Get this from flags.
  let api_url = "https://frustrated-functor.dev/issuesapi/api/issues"
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
    view_issue_body(model),
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
          |> list.map(view_issue),
      )
    _ -> html.span([], [])
  }
}

fn view_issue(issue: Issue) -> element.Element(Msg) {
  html.div(
    [
      attr.class(
        "flex flex-col justify-between gap-2 shadow-md border rounded-md p-2",
      ),
      event.on_mouse_enter(message.ShowIssueBody(issue)),
      event.on_mouse_leave(message.ClearIssueBody),
    ],
    [
      html.span([attr.class("text-lg")], [html.text(issue.title)]),
      html.a(
        [
          attr.href(issue.url),
          attr.target("_blank"),
          attr.class("text-blue-400 underline"),
        ],
        [html.text("See on GitHub")],
      ),
    ],
  )
}

fn view_issue_body(model: Model) -> element.Element(Msg) {
  case model {
    Model(current_issue: option.Some(issue), ..) ->
      html.div(
        [
          attr.id(issue.id |> int.to_string),
          attr.class(
            "border rounded-md shadow-md md:my-[10px] p-2 fixed bottom-20 z-10 bg-white w-[60%] animate-enter-from-below",
          ),
        ],
        [
          html.small([attr.class("text-gray-400")], [
            html.text("Issue description"),
          ]),
          html.h2([attr.class("text-lg font-bold")], [html.text(issue.title)]),
          html.text(issue.body),
        ],
      )
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
