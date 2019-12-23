--[[
  @author Digital.
  @url https://github.com/dig/onset-camera-library
]]

local CameraTimer = 0
local CameraRotation = 0

local CameraStayInCamera = false

local function Pan_OnCameraTick(center, distance, speed, offset)
  if CameraState ~= CAMERA_ENABLED then return end

  CameraRotation = CameraRotation + speed
  if CameraRotation >= 360 then
    CameraRotation = (CameraRotation - 360)
  end

  -- Location
  local rx, ry, rz = RotationToVector(0, CameraRotation, 0)
  SetCameraLocation(center[1] + (rx * distance) + offset[1], center[2] + (ry * distance) + offset[2], center[3] + (rz * distance) + offset[3], true)

  -- Direction
  local x, y, z = GetCameraLocation()
  local dX = center[1] - x
  local dY = center[2] - y
  local dZ = center[3] - z

  local yaw = math.atan(dY, dX) * 180.0 / 3.14159265359;
  local pitch = math.asin(dZ / math.sqrt(dY * dY + dX * dX)) * 180.0 / 3.14159265359;

  SetCameraRotation(pitch, yaw, 0, true)
end

local function Pan_StartCamera(center, distance, speed, offset, stayInCamera)
  if (center == nil or distance == nil or speed == nil or CameraState ~= CAMERA_DISABLED) then return end
  if offset == nil then
    offset = { 0, 0, 0 }
  end

  if stayInCamera == nil then
    CameraStayInCamera = false
  else
    CameraStayInCamera = stayInCamera
  end

  SetIgnoreLookInput(true)
  SetIgnoreMoveInput(true)

  CameraTimer = CreateTimer(Pan_OnCameraTick, 10, center, distance, speed, offset)
  CameraState = CAMERA_ENABLED

  CallEvent('OnCameraStart', CAMERA_PAN)
end
AddFunctionExport('StartCameraPan', Pan_StartCamera)

local function Pan_OnStopCamera()
  if (CameraState == CAMERA_ENABLED and CameraTimer ~= 0) then
    DestroyTimer(CameraTimer)

    if not CameraStayInCamera then
      SetCameraLocation(0, 0, 0, false)
      SetCameraRotation(0, 0, 0, false)

      SetIgnoreLookInput(false)
      SetIgnoreMoveInput(false)
    end

    CallEvent('OnCameraStop', CAMERA_PAN)
  end
end
AddEvent('_OnStopCamera', Pan_OnStopCamera)