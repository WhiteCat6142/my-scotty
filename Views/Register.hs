{-# LANGUAGE OverloadedStrings #-}

module Views.Register (register) where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson (object, (.=))
import Network.HTTP.Types.Status
import Web.Scotty
import Data.Text.Lazy(Text)

{- 
24 Days of Hackage: scotty
https://blog.ocharles.org.uk/blog/posts/2013-12-05-24-days-of-hackage-scotty.html
https://github.com/ocharles/blog/blob/master/code/2013-12-05-scotty.hs

curl -X POST 'localhost:3000/register?email=a@b.com' 
-}

register :: ActionM ()
register = register0 `rescue` registrationFailure

register0 :: ActionM ()
register0 = do
  emailAddress <- param "email"
  let registered = registerInterest emailAddress
  case registered of
    Left errorMessage -> do
      json $ object [ "error" .= errorMessage ]
      status internalServerError500

    Right msg -> do
      liftIO.print$msg
      json $ object [ "ok" .= ("ok" :: String) ]

registrationFailure :: Text->ActionM ()
registrationFailure errorMessage= do
  json $ object [ "error" .= ("Invalid request" :: String) ]
  status badRequest400

registerInterest :: String -> Either String String
registerInterest "a@b.com" = Right "Registered!"
registerInterest _ = Left "I broke :("
