{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NamedFieldPuns #-}

module DinoRush.Manager.Input where

import Control.Monad.State
import DinoRush.Engine.Input
import DinoRush.State
import DinoRush.Wrapper.SDLInput
import KeyState
import qualified SDL

class Monad m => HasInput m where
  updateInput :: m ()
  setInput :: Input -> m ()
  getInput :: m Input

updateInput' :: (HasInput m, SDLInput m) => m ()
updateInput' = do
  input <- getInput
  events <- pollEventPayloads
  setInput (stepControl events input)

getInput' :: MonadState Vars m => m Input
getInput' = gets vInput

setInput' :: MonadState Vars m => Input -> m ()
setInput' input = modify (\v -> v {vInput = input})

stepControl :: [SDL.EventPayload] -> Input -> Input
stepControl events Input {iSpace, iUp, iDown, iEscape} =
  Input
    { iSpace = next 1 [SDL.KeycodeSpace] iSpace,
      iUp = next 1 [SDL.KeycodeUp, SDL.KeycodeW] iUp,
      iDown = next 1 [SDL.KeycodeDown, SDL.KeycodeS] iDown,
      iEscape = next 1 [SDL.KeycodeEscape] iEscape,
      iQuit = SDL.QuitEvent `elem` events
    }
  where
    next count keycodes keystate
      | any pressed keycodes = pressedKeyState
      | any released keycodes = releasedKeyState
      | otherwise = maintainKeyState count keystate
    released keycode = any (keycodeReleased keycode) events
    pressed keycode = any (keycodePressed keycode) events
