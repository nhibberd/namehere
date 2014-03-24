module Toaster.Prelude (
  module X
) where

import Prelude as X hiding (writeFile, readFile, head, tail, init, last, mapM, length, null, all)
import Control.Applicative as X (Applicative, (<$>), (<*>), (*>), (<*), pure)
import Control.Monad as X (void, forever, when, unless, liftM, return, (>>=), (>>), Monad, ap, replicateM)
import Control.Monad.IO.Class as X (MonadIO, liftIO)
import Control.Monad.Trans as X (MonadTrans, lift)
import Data.Traversable as X (mapM)
import Data.Text as X (Text)
import Data.Maybe as X (listToMaybe)