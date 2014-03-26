{-# LANGUAGE OverloadedStrings, TemplateHaskell, DeriveGeneric, ScopedTypeVariables #-}
module Toaster.Http (module X, toastermain) where

import Toaster.Http.Prelude as X
import Toaster.Http.Message as X

import Web.Scotty

import Control.Lens

import Database.PostgreSQL.Simple

import Data.Pool
import Network.HTTP.Types (status200)

import Data.ByteString.Lazy.Internal
import Debug.Trace

toastermain :: Pool Connection -> ScottyM ()
toastermain pool = do
    post "/test" $ do
      (m :: String) <- jsonData
      json m

    post "/message" $ do
      (m :: Message) <- jsonData
      _ <- liftIO $ withResource pool $ \c -> do
        create c (m^.message)
      status status200

    get "/messages" $ do
      v <- liftIO $ withResource pool $ \c -> do
        retrieveAll c
      json v

-- god this is terrible... plz fix
    get "/test/messages" $ do
      (m :: Maybe Message) <- (jsonData) `rescue` (\_ -> return undefined)
      v <- liftIO $ withResource pool $ \c -> do
        case (trace (show m) m) of
          Just (Message i _) -> retrieve i c  
          _ -> retrieveAll c      
      json v

    get "" $ do
      redirect "/index.html"

    get "/" $ do
      redirect "/index.html"

    notFound $ do
      text "there is no such route."