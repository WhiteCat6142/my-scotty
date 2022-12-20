{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Controllers.Home
    ( home, postx, chrstmsly) where

import           Views.Home (homeView)
import           Views.Register (register)

import           Web.Scotty (ScottyM, get, html, json, post)
import           Data.Aeson (ToJSON)
import           GHC.Generics

home :: ScottyM ()
home = get "/" homeView

chrstmsly :: ScottyM ()
chrstmsly = post "/register" register

data Post = Post
  { postId    :: Int
  , postTitle :: String } deriving Generic

instance ToJSON Post

postx :: ScottyM()
postx = get "/post" $ json $ Post 1 "Yello world"
