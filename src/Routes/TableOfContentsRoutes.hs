module Routes.TableOfContentsRoutes where

import Web.Scotty
import Controllers.TableOfContentsController
import Services.TableOfContentsService
import Utils.TableOfContentsUtils
import Models.TableOfContents

tableOfContentsRoutes :: ScottyM ()
tableOfContentsRoutes = do
  get "/table-of-contents" $ tableOfContentsRoute
  get "/table-of-contents/cache" $ tableOfContentsCacheRoute

tableOfContentsRoute :: ScottyM ()
tableOfContentsRoute = do
  markdownDoc <- param "markdownDoc"
  let toc = getTableOfContents markdownDoc
  json toc

tableOfContentsCacheRoute :: ScottyM ()
tableOfContentsCacheRoute = do
  markdownDoc <- param "markdownDoc"
  cacheManager <- liftIO $ getCacheManager
  toc <- liftIO $ getTableOfContentsFromCache cacheManager markdownDoc
  json toc