module DinoRush.Scene.Pause where

import Control.Monad (when)
import Control.Monad.State (MonadState)
import DinoRush.Effect.Camera
import DinoRush.Effect.HUD
import DinoRush.Effect.Renderer
import DinoRush.Engine.Common
import DinoRush.Engine.Input
import DinoRush.Engine.Play
import DinoRush.Manager.Input
import DinoRush.Manager.Scene
import DinoRush.Scene.Play
import KeyState

class Monad m => Pause m where
  pauseStep :: m ()

pauseStep' :: (HasPlayVars s, HasCommonVars s, MonadState s m, SceneManager m, HasInput m, Renderer m, CameraControl m, HUD m) => m ()
pauseStep' = do
  input <- getInput
  drawPlay
  drawPause
  when (ksStatus (iSpace input) == KeyStatus'Pressed) (toScene Scene'Play)

drawPause :: (Renderer m, CameraControl m) => m ()
drawPause = do
  drawBlackOverlay 0.8
  disableZoom
  drawPauseText (530, 270)
  enableZoom
