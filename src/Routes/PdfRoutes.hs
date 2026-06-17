module Src.Routes.PdfRoutes where

import qualified Web.Scotty as Scotty
import Src.Controllers.PdfController (pdfController)
import Src.Utils.ErrorHandling (handleError)

pdfRoutes :: Scotty.ScottyM ()
pdfRoutes = do
  Scotty.route "/pdf" $ do
    Scotty.post pdfController
  Scotty.error $ \e -> do
    handleError $ "Error handling PDF request: " ++ show e
    Scotty.status 500
    Scotty.text "Internal Server Error"

pdfRouteMiddleware :: Scotty.Middleware
pdfRouteMiddleware = Scotty.middleware $ \next -> do
  Scotty.route "/pdf" $ do
    Scotty.post pdfController
  next