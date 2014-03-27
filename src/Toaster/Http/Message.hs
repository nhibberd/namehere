{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Toaster.Http.Message where

import           Toaster.Http.Prelude
import           Data.Aeson
import           Control.Lens           hiding ((.=))
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.FromRow
import           Data.Text (Text)

data Message = Message
    { _idd :: Maybe Int
    , _message :: Text
    } deriving (Eq, Show)

makeLenses ''Message

instance FromJSON Message where
    parseJSON (Object v) = Message <$>
                           v .:? "id" <*>
                           v .: "message"
    parseJSON _          = mzero
instance ToJSON Message where
    toJSON (Message i m ) = object ["id" .= i, "message" .= m]


instance FromRow Message where
  fromRow = Message <$> field <*> field

create :: Connection -> Text -> IO ()
create c d =
  void . withTransaction c $ execute c "insert into messages (message) values (?)" (Only d)

retrieveInit :: Connection -> IO [Message]
retrieveInit c =
  withTransaction c $ query_ c "SELECT id, message FROM messages ORDER BY id DESC LIMIT 10"

retrieve :: Int -> Connection -> IO [Message]
retrieve i c =
  withTransaction c $ query c "SELECT id, message FROM messages where id<(?) ORDER BY id DESC LIMIT 10" (Only i)

retrieveSince :: Int -> Connection -> IO [Message]
retrieveSince i c =
  withTransaction c $ query c "SELECT id, message FROM messages where id>(?) ORDER BY id DESC" (Only i)