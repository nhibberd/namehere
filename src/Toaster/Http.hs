{-# LANGUAGE OverloadedStrings, TemplateHaskell, DeriveGeneric, ScopedTypeVariables #-}
module Toaster.Http (toastermain) where

import Toaster.Http.Prelude
import Toaster.Http.Message
import Web.Scotty


toastermain ::ScottyM ()
toastermain = do
    post "/message" $ do
      (m :: Message) <- jsonData
      json m

    get "/messages" $ do
      undefined

    notFound $ do
      text "there is no such route."
