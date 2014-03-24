{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Toaster.Http.Core where

import           Toaster.Http.Prelude

import           Data.ByteString
import qualified Data.ByteString.Char8 as C8
import           Data.Maybe
import           Data.Pool

import           Database.PostgreSQL.Simple
import           Database.Migrate
import           Database.Migrate.Migration.FileStandard

import           System.Posix.Env

data Hole = Hole

connectInfo :: ConnectInfo
connectInfo = ConnectInfo {
                       connectHost = "localhost"
                     , connectPort = 5432
                     , connectUser = "toaster"
                     , connectPassword = "password"
                     , connectDatabase = "toasterdb"
                     }

mkpool :: IO (Pool Connection)
mkpool =
  createPool
    (connect connectInfo)       -- open action
    close                              -- close action
    1                                  -- stripes
    20                                 -- max keep alive (s)
    10                      -- max connections

migrations :: [Migration]
migrations = [
    migration "20140324" "initial"
  ]

runmigrate :: Pool Connection ->  IO ()
runmigrate pool =
  withResource pool $ \c ->
    withTransaction c $
      migrate "toaster" c "config/db" migrations