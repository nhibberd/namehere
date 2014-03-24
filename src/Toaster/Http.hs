{-# LANGUAGE OverloadedStrings, TemplateHaskell, DeriveGeneric, ScopedTypeVariables #-}
module Toaster.Http (toastermain) where

import Web.Scotty


toastermain ::ScottyM ()
toastermain = do
    post "/message" $ do
      _ <- jsonData
      undefined

    get "/messages" $ do
      undefined
