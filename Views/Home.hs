{-# LANGUAGE OverloadedStrings #-}

module Views.Home (homeView) where

import           Data.Monoid                 (mempty)
import           Data.Text.Lazy              (toStrict)
import           Prelude                     hiding (div, head, id)
import           Text.Blaze.Html             (Html, toHtml)
import           Text.Blaze.Html5            
import           Text.Blaze.Html5.Attributes (charset, class_, content, href,
                                              httpEquiv, id, media, name,
                                              placeholder, rel, src, type_)
import           Views.Utils                 (blaze, pet)
import           Web.Scotty                  (ActionM)

layout :: Html -> Html -> Html
layout t b = docTypeHtml $ do
           head $ do
             title t
             meta ! charset "utf-8"
             meta ! name "description" ! content "Inspire Text"
             meta ! name "viewport" ! content "width=device-width"
             link ! href "https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" ! rel  "stylesheet" ! media "screen"
             link ! href "cow.css" ! rel  "stylesheet"
           body $ do
             navBar >> b
             script ! src "https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js" $ mempty
             script ! src "https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js" $ mempty

homeView :: ActionM ()
homeView = blaze $ layout "home" $ do
             div ! class_ "container" $ do
               div ! class_ "jumbotron" $ do
                 h1 "Scotty Starter"
                 p "Welcome to the Scotty Starter template, equipped with Twitter Bootstrap 3.0 and HTML5 boilerplate"
                 p $ do a ! class_ "btn btn-lg btn-primary" ! id "fb" ! href "#navbar" $ "Facebook"
                        a ! class_ "btn btn-lg btn-danger" ! id "gmail" ! href "#navbar" $ "Gmail"

navBar :: Html
navBar = div ! class_ "navbar navbar-default navbar-static-top" $ div ! class_ "container" $ do
           div ! class_ "navbar-header" $ do
             button ! type_ "button"
                    ! class_ "navbar-toggle" ! dataAttribute "toggle" "collapse" ! dataAttribute "target" ".navbar-collapse" $ do
               a ! class_ "navbar-brand" ! href "#" $ "λ"
           div ! class_ "navbar-collapse collapse" $ ul ! class_ "nav navbar-nav" $ do
             li ! class_ "active" $ a ! href "#" $ "Home"
             li $ a ! href "#about" $ "About"
             li $ a ! href "#contact" $ "Contact"




