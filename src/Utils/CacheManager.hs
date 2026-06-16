-- | CacheManager module for managing in-memory cache with TTL
module Utils.CacheManager (
  CacheManager,
  newCacheManager,
  getCache,
  setCache,
  deleteCache,
  cacheSize
) where

import Control.Monad (liftM2)
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as HM
import Data.Time (UTCTime, NominalDiffTime, getCurrentTime, addUTCTime)
import Data.Time.Clock (secondsToNominalDiffTime)

-- | CacheManager data type
data CacheManager = CacheManager {
  cache :: HashMap String (UTCTime, String),
  ttl :: NominalDiffTime
} deriving (Show)

-- | Create a new CacheManager instance
newCacheManager :: NominalDiffTime -> IO CacheManager
newCacheManager ttl = do
  return $ CacheManager HM.empty ttl

-- | Get a value from the cache
getCache :: CacheManager -> String -> IO (Maybe String)
getCache cacheManager key = do
  currentTime <- getCurrentTime
  let cache = cache cacheManager
      value = HM.lookup key cache
  case value of
    Just (expirationTime, value) -> do
      if expirationTime > currentTime
        then return $ Just value
        else do
          deleteCache cacheManager key
          return Nothing
    Nothing -> return Nothing

-- | Set a value in the cache
setCache :: CacheManager -> String -> String -> IO ()
setCache cacheManager key value = do
  currentTime <- getCurrentTime
  let expirationTime = addUTCTime (ttl cacheManager) currentTime
      cache = cache cacheManager
  let newCache = HM.insert key (expirationTime, value) cache
  return $ cacheManager { cache = newCache }

-- | Delete a value from the cache
deleteCache :: CacheManager -> String -> IO ()
deleteCache cacheManager key = do
  let cache = cache cacheManager
      newCache = HM.delete key cache
  return $ cacheManager { cache = newCache }

-- | Get the size of the cache
cacheSize :: CacheManager -> IO Int
cacheSize cacheManager = do
  let cache = cache cacheManager
  return $ HM.size cache

-- Example usage:
main :: IO ()
main = do
  cacheManager <- newCacheManager (secondsToNominalDiffTime 3600) -- 1 hour TTL
  setCache cacheManager "key" "value"
  value <- getCache cacheManager "key"
  print value
  cacheSize' <- cacheSize cacheManager
  print cacheSize'