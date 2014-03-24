{-# LANGUAGE OverloadedStrings, TemplateHaskell, DeriveGeneric, ScopedTypeVariables #-}
module Toaster.Http (module X, toastermain) where

import Toaster.Http.Prelude as X
import Toaster.Http.Message as X

import Web.Scotty

import Control.Lens

import Database.PostgreSQL.Simple

import Data.Pool
import           Data.Text (pack)
import Network.HTTP.Types (status200)


toastermain :: Pool Connection -> ScottyM ()
toastermain pool = do
    post "/test" $ do
      (m :: Message) <- jsonData
      json m

    post "/message" $ do
      (m :: Message) <- jsonData
      _ <- liftIO $ withResource pool $ \c -> do
        create c (pack $ m^.message)
      status status200

    get "/messages" $ do
      v <- liftIO $ withResource pool $ \c -> do
        retrieveAll c
      json v

    notFound $ do
      text "there is no such route."