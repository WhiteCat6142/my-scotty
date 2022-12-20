{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeApplications #-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell, RankNTypes #-}

module Main where

import           Control.Monad
import           Control.Applicative
import           Controllers.Home                     (home, postx, chrstmsly)
import           Data.Maybe                           (fromMaybe)
import           Network.Wai.Middleware.RequestLogger (logStdoutDev)
import           Network.Wai.Middleware.Static        (addBase, noDots,staticPolicy, (>->))
import           System.Environment                   (lookupEnv)
import           Text.Read                            (readMaybe)
import           Web.Scotty                           (middleware, scotty,ScottyM)

import GHC.Generics
import Control.Monad.Trans.Reader
import Control.Lens
import Control.Monad.IO.Class (liftIO)

{-
Higher-Kinded Data (HKD) について
https://qiita.com/thimura/items/85bdeeca6ced74c89478

Building a JSON REST API in Haskell · taylor.fausak.me
http://taylor.fausak.me/2014/10/21/building-a-json-rest-api-in-haskell/

【Control.Monad.Trans】(4) ReaderTモナド - Qiita
https://qiita.com/sand/items/93d6ba75b0c4e39ce295

Haskell/Lenses and functional references - Wikibooks, open books for an open world
https://en.wikibooks.org/wiki/Haskell/Lenses_and_functional_references

Evaluating RIO | Freckle Education
https://tech.freckle.com/2019/04/16/evaluating-rio/

Hasパターンとは - Qiita
https://qiita.com/sparklingbaby/items/b6c0e87c0299286e5e17

rio ライブラリを試す その１
https://matsubara0507.github.io/posts/2018-04-13-try-rio-1.html
-}

data Env_ f = Env_
  { _environment_ :: f String
  , _port_ :: f Int
  } deriving Generic
makeLenses ''Env_

data Env = Env
  { _environment :: !String
  , _port :: !Int
  } deriving Generic
makeLenses ''Env

validate :: Env_ Maybe -> Maybe Env
validate s=
    Env <$> _environment_ s <*> _port_ s

main :: IO ()
main =  (setdefault<$>getEnv)>>=runReaderT run

getEnv :: IO (Env_ Maybe)
getEnv = do
   e <- lookupEnv "SCOTTY_ENV"
   p <- lookupEnv "PORT"
   return $ Env_ e  (p>>=readMaybe)

setdefault :: Env_ Maybe->Env
setdefault c=
      Env (fromMaybe "dev" $ _environment_ c) (fromMaybe 3000 $ _port_ c)

class Hasport a where
  portL :: Lens' a Int

instance Hasport Env where
 portL = port

run :: (Hasport e)=>ReaderT e IO ()
run= view portL >>=  liftIO. ((flip scotty) page)

page::ScottyM ()
page=do
         middleware $ staticPolicy (noDots >-> addBase "Static")
         middleware logStdoutDev
         home >> postx >> chrstmsly
