import qualified Toaster.Http as Http
import Web.Scotty
import Network.Wai.Middleware.RequestLogger

main :: IO ()
main = do
  scotty 3000 $ do
  middleware logStdoutDev
  Http.toastermain