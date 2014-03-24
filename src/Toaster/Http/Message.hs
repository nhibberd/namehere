{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Toaster.Http.Message where

import           Toaster.Http.Prelude
import           Data.Aeson    
import           Control.Lens           hiding ((.=))
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.FromRow

data Message = Message 
    { _message :: Text
    } deriving (Eq, Show)

makeLenses ''Message

instance FromJSON Message where
    parseJSON (Object v) = Message <$>
                           v .: "message"
    parseJSON _          = mzero
instance ToJSON Message where
    toJSON (Message m ) = object ["message" .= m]


instance FromRow Message where
  fromRow = Message <$> field

create :: Connection -> Text -> IO ()
create c d =
  void . withTransaction c $ execute c "insert into messages (message) values (?)" (Only d)

retrieveAll :: Connection -> IO [Message]
retrieveAll c =
 withTransaction c $ query_ c "SELECT id, message FROM messages"