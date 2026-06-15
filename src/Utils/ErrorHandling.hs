-- | Error handling utilities
module Utils.ErrorHandling where

import Control.Monad (liftIO)
import Data.Text (Text)
import qualified Data.Text as T
import Web.Scotty

-- | Handle PandocError and return a JSON error response
handlePandocError :: PandocError -> ActionM ()
handlePandocError err = json $ T.pack $ show err

-- | Handle any exception and return a JSON error response
handleException :: Exception -> ActionM ()
handleException err = json $ T.pack $ show err

-- | Catch and handle any exceptions in an ActionM
catchExceptions :: ActionM () -> ActionM ()
catchExceptions action = do
  liftIO $ catch action handleException
  where
    catch :: IO a -> (Exception -> IO a) -> IO a
    catch = Control.Exception.catch