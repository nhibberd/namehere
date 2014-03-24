{-# LANGUAGE OverloadedStrings, TemplateHaskell, DeriveGeneric, ScopedTypeVariables #-}
module Toaster.Http (module X, toastermain) where

import Toaster.Http.Prelude as X
import Toaster.Http.Message as X

import Web.Scotty

import Database.PostgreSQL.Simple

import Data.Pool


toastermain :: Pool Connection -> ScottyM ()
toastermain pool = do
    post "/test" $ do
      (m :: Message) <- jsonData
      json m

    post "/message" $ do
      json (Message "foo")

    get "/messages" $ do
      undefined

    notFound $ do
      text "there is no such route."
