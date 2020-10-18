{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NamedFieldPuns #-}

module DinoRush.Effect.Renderer where

import qualified Animate
import Control.Monad.Reader
import Data.StateVar (($=))
import DinoRush.Config
import DinoRush.Engine.Bird
import DinoRush.Engine.Dino
import DinoRush.Engine.Font
import DinoRush.Engine.Lava
import DinoRush.Engine.Mountain
import DinoRush.Engine.River
import DinoRush.Engine.Rock
import DinoRush.Engine.Types
import DinoRush.Wrapper.SDLRenderer
import Foreign.C.Types
import qualified SDL
import SDL.Vect

class Monad m => Renderer m where
  clearScreen :: m ()
  drawScreen :: m ()
  getDinoAnimations :: m (Animations DinoKey)
  getLavaAnimations :: m (Animations LavaKey)
  getRockAnimations :: m (Animations RockKey)
  getBirdAnimations :: m (Animations BirdKey)
  getMountainAnimations :: m (Animations MountainKey)
  getRiverAnimations :: m (Animations RiverKey)
  drawDino :: DrawSprite DinoKey m
  drawLava :: DrawSprite LavaKey m
  drawRock :: DrawSprite RockKey m
  drawBird :: DrawSprite BirdKey m
  drawMountain :: DrawSprite MountainKey m
  drawRiver :: DrawSprite RiverKey m
  drawJungle :: (Int, Int) -> m ()
  drawGround :: (Int, Int) -> m ()
  drawBlackOverlay :: Percent -> m ()
  drawHiscoreText :: (Int, Int) -> m ()
  drawPauseText :: (Int, Int) -> m ()
  drawGameOverText :: (Int, Int) -> m ()
  drawPressSpaceText :: (Int, Int) -> m ()
  drawPressEscapeText :: (Int, Int) -> m ()
  drawTitleText :: (Int, Int) -> m ()
  drawNumber :: Number -> (Int, Int) -> m ()
  drawControlsText :: (Int, Int) -> m ()

clearScreen' :: (SDLRenderer m, MonadReader Config m) => m ()
clearScreen' = do
  renderer <- asks cRenderer
  clearRenderer renderer

drawScreen' :: (SDLRenderer m, MonadReader Config m) => m ()
drawScreen' = do
  renderer <- asks cRenderer
  presentRenderer renderer

--

mountainY, jungleY, groundY, riverY :: Int
mountainY = -16
jungleY = 16 * 0
groundY = 16 * 28
riverY = 16 * 36

--

drawTextureSprite :: (SDLRenderer m, MonadReader Config m) => (Config -> SDL.Texture) -> (Int, Int) -> m ()
drawTextureSprite getTex (x, y) = do
  renderer <- asks cRenderer
  tex <- asks getTex
  SDL.TextureInfo {textureWidth, textureHeight} <- queryTexture tex
  let dim = V2 textureWidth textureHeight
  drawTexture
    renderer
    tex
    Nothing
    (Just $ SDL.Rectangle (SDL.P $ SDL.V2 (fromIntegral x) (fromIntegral y)) dim)

drawSprite :: (SDLRenderer m, MonadReader Config m) => (Config -> Animate.SpriteSheet key SDL.Texture Seconds) -> Animate.SpriteClip key -> (Int, Int) -> m ()
drawSprite ss clip (x, y) = do
  renderer <- asks cRenderer
  sheet <- asks (Animate.ssImage . ss)
  let clip'@(SDL.Rectangle _ dim) = rectFromClip clip
  drawTexture
    renderer
    sheet
    (Just clip')
    (Just $ SDL.Rectangle (SDL.P $ SDL.V2 (fromIntegral x) (fromIntegral y)) dim)

drawHorizontalScrollSprite :: (MonadReader Config m, SDLRenderer m) => (Config -> Animate.SpriteSheet key SDL.Texture Seconds) -> Int -> Animate.SpriteClip key -> (Int, Int) -> m ()
drawHorizontalScrollSprite ss scale clip (x, y) = do
  renderer <- asks cRenderer
  sheet <- asks (Animate.ssImage . ss)
  let clip'@(SDL.Rectangle _ dim) = rectFromClip clip
  let dim' = fromIntegral scale *^ dim
  drawTexture renderer sheet (Just clip') (Just $ SDL.Rectangle (SDL.P $ SDL.V2 (fromIntegral x - 1280) (fromIntegral y)) dim')
  drawTexture renderer sheet (Just clip') (Just $ SDL.Rectangle (SDL.P $ SDL.V2 (fromIntegral x) (fromIntegral y)) dim')
  drawTexture renderer sheet (Just clip') (Just $ SDL.Rectangle (SDL.P $ SDL.V2 (fromIntegral x + 1280) (fromIntegral y)) dim')

getSpriteAnimations :: (MonadReader Config m) => (Config -> Animate.SpriteSheet key SDL.Texture Seconds) -> m (Animations key)
getSpriteAnimations ss = asks (Animate.ssAnimations . ss)

drawHorizontalScrollImage :: (MonadReader Config m, SDLRenderer m) => (Config -> SDL.Texture) -> Int -> (Int, Int) -> m ()
drawHorizontalScrollImage getTex scale (x, y) = do
  renderer <- asks cRenderer
  tex <- asks getTex
  SDL.TextureInfo {textureWidth, textureHeight} <- queryTexture tex
  let dim = SDL.V2 textureWidth textureHeight
  let dim' = fromIntegral scale *^ dim
  drawTexture renderer tex Nothing (Just $ SDL.Rectangle (SDL.P $ SDL.V2 (fromIntegral x - 1280) (fromIntegral y)) dim')
  drawTexture renderer tex Nothing (Just $ SDL.Rectangle (SDL.P $ SDL.V2 (fromIntegral x) (fromIntegral y)) dim')
  drawTexture renderer tex Nothing (Just $ SDL.Rectangle (SDL.P $ SDL.V2 (fromIntegral x + 1280) (fromIntegral y)) dim')

drawBlackOverlay' :: (MonadReader Config m, SDLRenderer m, MonadIO m) => Percent -> m ()
drawBlackOverlay' (Percent percent) = do
  renderer <- asks cRenderer
  SDL.rendererDrawBlendMode renderer $= SDL.BlendAlphaBlend
  SDL.rendererDrawColor renderer $= V4 0 0 0 (truncate $ 255 * percent)
  SDL.fillRect renderer Nothing
  SDL.rendererDrawBlendMode renderer $= SDL.BlendNone

--

rectFromClip :: Animate.SpriteClip key -> SDL.Rectangle CInt
rectFromClip Animate.SpriteClip {scX, scY, scW, scH} = SDL.Rectangle (SDL.P (V2 (num scX) (num scY))) (V2 (num scW) (num scH))
  where
    num = fromIntegral

stepHorizontalDistance :: Distance -> Distance -> Distance
stepHorizontalDistance dist speed = if dist' <= -1280 then dist' + 1280 else dist'
  where
    dist' = dist + speed
