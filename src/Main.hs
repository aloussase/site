module Main where

import Web.Scotty

main :: IO ()
main = scotty 3000 $ do
    get "/" $ do
        setHeader "Content-Type" "text/html"
        file "index.html"
