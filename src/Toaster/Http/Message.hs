{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Toaster.Http.Message ( 
    Message(..)
  , FromJSON
  , ToJSON 
  ) where

import Toaster.Http.Prelude
import Toaster.Http.Core
import Data.Aeson    
import Data.Bool
import Control.Lens           hiding ((.=))

data Message = Message 
    { _message :: String
    } deriving (Eq, Show)

makeLenses ''Message

instance FromJSON Message where
    parseJSON (Object v) = Message <$>
                           v .: "message"
    parseJSON _          = mzero
instance ToJSON Message where
    toJSON (Message m ) = object ["message" .= m]
