-- | In-memory cache with TTL for API responses
module Utils.Cache where

import Control.Monad (liftM2)
import Control.Monad.IO.Class (liftIO)
import Data.Cache (Cache, CacheConfig, newCache, getCache, putCache, deleteCache)
import Data.Time (NominalDiffTime, UTCTime, getCurrentTime, addUTCTime)
import qualified Data.Map as M

-- | Cache configuration
cacheConfig :: CacheConfig
cacheConfig = CacheConfig
  { cacheMaxSize = 1000
  , cacheTimeToLive = 60 -- 1 minute
  }

-- | Create a new cache
newCacheIO :: IO (Cache String String)
newCacheIO = newCache cacheConfig

-- | Get a value from the cache
getCacheValue :: Cache String String -> String -> IO (Maybe String)
getCacheValue cache key = getCache cache key

-- | Put a value into the cache
putCacheValue :: Cache String String -> String -> String -> IO ()
putCacheValue cache key value = putCache cache key value

-- | Delete a value from the cache
deleteCacheValue :: Cache String String -> String -> IO ()
deleteCacheValue cache key = deleteCache cache key

-- | Check if a key is in the cache
isKeyInCache :: Cache String String -> String -> IO Bool
isKeyInCache cache key = liftM2 (||) (isJust <$> getCacheValue cache key) (key `M.member` cache)

-- | Get the current time
getCurrentTimeIO :: IO UTCTime
getCurrentTimeIO = liftIO getCurrentTime

-- | Add a TTL to a cache value
addTTL :: NominalDiffTime -> UTCTime -> UTCTime
addTTL ttl time = addUTCTime ttl time

-- | Check if a cache value has expired
isCacheValueExpired :: UTCTime -> IO Bool
isCacheValueExpired expirationTime = do
  currentTime <- getCurrentTimeIO
  return $ currentTime > expirationTime

-- | Example usage
exampleUsage :: IO ()
exampleUsage = do
  cache <- newCacheIO
  putCacheValue cache "key" "value"
  value <- getCacheValue cache "key"
  print value