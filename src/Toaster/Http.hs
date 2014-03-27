{-# LANGUAGE OverloadedStrings, TemplateHaskell, DeriveGeneric, ScopedTypeVariables, FlexibleInstances #-}
module Toaster.Http (module X, toastermain) where

import Toaster.Http.Prelude as X
import Toaster.Http.Message as X

import Web.Scotty

import Control.Lens

import Database.PostgreSQL.Simple

import Data.Pool

import Network.HTTP.Types (status200)

toastermain :: Pool Connection -> ScottyM ()
toastermain pool = do
    post "/message" $ do
      (m :: Message) <- jsonData
      _ <- liftIO $ withResource pool $ \c -> do
        create c (m^.message)
      status status200

    get "/messages" $ do
      (m :: [Message]) <- (param "id" >>=
                           \i -> liftIO . handler pool $ retrieve i) `rescue` \_ -> liftIO $ handler pool retrieveInit
      json m

    get "" $ do
      redirect "/index.html"

    get "/" $ do
      redirect "/index.html"

    notFound $ do
      text "there is no such route."

handler :: Pool Connection -> (Connection -> IO [Message]) -> IO [Message]
handler pool f =
  withResource pool $ \c -> do
    f c
