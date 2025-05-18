module Main where

import           Web.Scotty

main :: IO ()
main = scotty 3000 $ do
    get "/styles.css" $ do
      setHeader "Content-Type" "text/css"
      file "styles.css"

    get "/" $ do
      setHeader "Content-Type" "text/html"
      file "index.html"
