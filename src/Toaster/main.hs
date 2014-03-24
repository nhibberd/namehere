import qualified Toaster.Http as Http
import           Toaster.Http.Core

import           Network.Wai.Middleware.RequestLogger

import           Web.Scotty

main :: IO ()
main = do
  pool <- mkpool    
  runmigrate pool
  scotty 3000 $ do
  middleware logStdoutDev
  Http.toastermain pool