module Routes.TextRoutes where

import Web.Scotty (ScottyM, middleware)
import qualified Web.Scotty as Scotty
import Controllers.TextController (initTextController)

-- | Initializes the text routes
initTextRoutes :: ScottyM ()
initTextRoutes = do
  middleware $ \next -> \req -> do
    res <- next req
    return res
  initTextController

-- | Mounts the text routes
mountTextRoutes :: ScottyM ()
mountTextRoutes = Scotty.scope "/api" initTextRoutes