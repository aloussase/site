module Main exposing (..)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes as A
import Html.Events as E


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { counter : Int }


type Msg
    = Click


init : () -> ( Model, Cmd Msg )
init () =
    ( { counter = 0 }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Document Msg
view model =
    { title = "Alexander Goussas"
    , body =
        [ header_
        , main_ []
            [ distSysClub
            , posts
            ]
        ]
    }


header_ : Html Msg
header_ =
    header
        []
        [ h2 [] [ text "Hey there! I AM" ]
        , hr [] []
        , h1 [] [ text "ALEXANDER GOUSSAS" ]
        , shortAbout
        , nav [] [ socials ]
        ]


socials : Html Msg
socials =
    let
        links =
            [ { name = "GitHub", to = "https://github.com/aloussase", icon = "fa-brands fa-github" }
            , { name = "Email", to = "mailto:goussasalexander@gmail.com", icon = "fa-solid fa-envelope" }
            , { name = "LinkedIn", to = "https://www.linkedin.com/in/aloussase/", icon = "fa-brands fa-linkedin" }
            , { name = "Twitter", to = "https://x.com/aloussase", icon = "fa-brands fa-twitter" }
            , { name = "Instagram", to = "https://www.instagram.com/aloussase/", icon = "fa-brands fa-instagram" }
            , { name = "Discord", to = "https://discord.gg/QqMnGrFKxn", icon = "fa-brands fa-discord" }
            ]
    in
    div
        [ A.class "socials" ]
        (List.map
            (\link ->
                a [ A.href link.to, A.target "_blank" ]
                    [ i [ A.class link.icon ] []
                    , span [ A.class "hidden" ] [ text link.name ]
                    ]
            )
            links
        )


shortAbout : Html Msg
shortAbout =
    div
        [ A.class "short-about" ]
        [ p [] [ text "I'm a programmer from Ecuador with keen interest in functional programming and distributed systems." ]
        , p [] [ text "Currently, I am working on my bachelor's thesis on distributed tracing while working as a consultant at a respectable software company TM." ]
        , p [] [ text "I love to talk all things software, so don't hesistate to reach out!" ]
        ]


distSysClub : Html Msg
distSysClub =
    div
        [ A.class "distsys" ]
        [ h3 [] [ text "Distributed Systems Club" ]
        , p [] [ text "I have a distributed systems club where we talk all things databases, compilers and distributed systems." ]
        , p [] [ text "We are currently going:" ]
        , ul []
            [ li [] [ text "Doing Fly.io's Distributed Systems challenges" ]
            , li [] [ text "Reading the book 'Database Design and Implementation'" ]
            ]
        , p []
            [ text "Contact me if you want to join! Or join our "
            , a [ A.href "https://discord.gg/QqMnGrFKxn", A.target "_blank" ] [ text "Discord server" ]
            , text "."
            ]
        ]


detailedAbout : Html Msg
detailedAbout =
    -- - kokoa
    -- - my studies
    -- - my work
    -- - my hobbies
    -- - what I'm currently doing
    -- - what I am aiming at
    div [] []


interests : Html Msg
interests =
    div [] []


languages : Html Msg
languages =
    div [] []


posts : Html Msg
posts =
    div [ A.class "posts" ]
        [ h3 [] [ text "Posts" ]
        , p [] [ text "Nothing for now :p" ]
        ]
