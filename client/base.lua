--[[
  @author Digital.
  @url https://github.com/dig/onset-camera-library
]]

CAMERA_DISABLED = 0
CAMERA_ENABLED = 1

CAMERA_PAN = 0
CAMERA_PATH = 1

CameraState = CAMERA_DISABLED

function Base_IsCameraEnabled()
  return CameraState == CAMERA_ENABLED
end
AddFunctionExport('IsCameraEnabled', Base_IsCameraEnabled)

function Base_StopCamera(ReturnToBody)
  CallEvent('_OnStopCamera')

  if ReturnToBody == nil then
    ReturnToBody = true
  end
  
  if ReturnToBody then
    SetCameraLocation(0, 0, 0, false)
    SetCameraRotation(0, 0, 0, false)
  end

  SetIgnoreLookInput(false)
  SetIgnoreMoveInput(false)

  CameraState = CAMERA_DISABLED
end
AddFunctionExport('StopCamera', Base_StopCamera)