module Config where

import Control.Monad (liftM2)
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)

-- Load environment variables from .env file
loadEnv :: IO (Maybe String)
loadEnv = lookupEnv "ENVIRONMENT"

-- Load configuration based on environment
loadConfig :: IO Config
loadConfig = do
  env <- loadEnv
  case env of
    Just "dev" -> return devConfig
    Just "prod" -> return prodConfig
    _ -> return devConfig

-- Development configuration
devConfig :: Config
devConfig = Config
  { markdownDir = "/tmp/markdown"
  , htmlDir = "/tmp/html"
  , pdfDir = "/tmp/pdf"
  }

-- Production configuration
prodConfig :: Config
prodConfig = Config
  { markdownDir = "/var/markdown"
  , htmlDir = "/var/html"
  , pdfDir = "/var/pdf"
  }

-- Configuration data type
data Config = Config
  { markdownDir :: String
  , htmlDir :: String
  , pdfDir :: String
  } deriving (Show)