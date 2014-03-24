{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Toaster.Http.Core where

import           Toaster.Http.Prelude

import           Data.ByteString
import qualified Data.ByteString.Char8 as C8
import           Data.Maybe
import           Data.Pool

import           Database.PostgreSQL.Simple

import           System.Posix.Env

data Hole = Hole

data Env =
  Env {
      database :: ByteString
    , poolsize :: Int
    }

environment :: IO Env
environment = do
  mdatabase <- getEnv "TEST_DB"
  mpoolsize <- getEnv "TEST_POOL"
  let db = maybe (error "Environment variable TEST_DB must be set.") C8.pack mdatabase
  let ps = maybe 10 read mpoolsize
  return $ Env db ps

mkpool :: Env -> IO (Pool Connection)
mkpool env =
  createPool
    (connectPostgreSQL $ database env) -- open action
    close                              -- close action
    1                                  -- stripes
    20                                 -- max keep alive (s)
    (poolsize env)                     -- max connections
