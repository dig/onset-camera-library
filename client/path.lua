--[[
  @author Digital.
  @url https://github.com/dig/onset-camera-library
]]

local CameraTimer = 0
local CameraTick = 10

local CameraCurrentIndex = 1
local CameraCurrentStep = 0

local CameraStayInCamera = false

local function Path_OnCameraTick(path, length, data, steps)
  if data[CameraCurrentIndex] == nil then return Base_StopCamera() end
  local _data = data[CameraCurrentIndex]

  local x, y, z = GetCameraLocation(false)
  local rx, ry, rz = GetCameraRotation()

  local nx, ny, nz = x + _data.sx, y + _data.sy, z + _data.sz
  local nrx, nry, nrz = rx + _data.srx, ry + _data.sry, rz + _data.srz

  SetCameraLocation(nx, ny, nz, true)
  SetCameraRotation(nrx, nry, nrz, true)
  CameraCurrentStep = CameraCurrentStep + 1

  if (CameraCurrentStep >= steps) then
    if CameraCurrentIndex >= (#path - 1) then
      Base_StopCamera()
    else
      CameraCurrentStep = 0
      CameraCurrentIndex = CameraCurrentIndex + 1

      local x, y, z, rx, ry, rz = path[CameraCurrentIndex][1], path[CameraCurrentIndex][2], path[CameraCurrentIndex][3], path[CameraCurrentIndex][4], path[CameraCurrentIndex][5], path[CameraCurrentIndex][6] 
      SetCameraLocation(x, y, z, true)
      SetCameraRotation(rx, ry, rz, true)
    end
  end
end

local function Path_StartCamera(path, length, stayInCamera)
  if (path == nil or length == nil or CameraState ~= CAMERA_DISABLED) then return end
  
  if stayInCamera == nil then
    CameraStayInCamera = false
  else
    CameraStayInCamera = stayInCamera
  end

  -- Validation of path
  local _isValidPaths = true
  for _, v in ipairs(path) do
    if #v ~= 6 then
      _isValidPaths = false
    end
  end
  if not _isValidPaths then return print('Camera: Paths are not defined correctly.') end

  CameraCurrentIndex = 1
  CameraCurrentStep = 0
  
  -- Calculate path steps
  local _data = {}
  local steps = (length / (#path - 1)) / CameraTick

  for i, current in ipairs(path) do
    if path[i + 1] ~= nil then
      local next = path[i + 1]

      local cx, cy, cz, crx, cry, crz = current[1], current[2], current[3], current[4], current[5], current[6]  
      local nx, ny, nz, nrx, nry, nrz = next[1], next[2], next[3], next[4], next[5], next[6]

      local srx = (nrx - crx) / steps
      local sry = (nry - cry) / steps
      local srz = (nrz - crz) / steps

      if nrx < 90 and crx > 270 then
        srx = ((360 - crx) / steps) + (nrx / steps)
      elseif crx < 90 and nrx > 270 then
        srx = -((crx / steps) + ((360 - nrx) / steps))
      end

      if nry < 90 and cry > 270 then
        sry = ((360 - cry) / steps) + (nry / steps)
      elseif cry < 90 and nry > 270 then
        sry = -((cry / steps) + ((360 - nry) / steps))
      end

      if nrz < 90 and crz > 270 then
        srz = ((360 - crz) / steps) + (nrz / steps)
      elseif crz < 90 and nrz > 270 then
        srz = -((crz / steps) + ((360 - nrz) / steps))
      end

      _data[i] = {
        sx = (nx - cx) / steps,
        sy = (ny - cy) / steps,
        sz = (nz - cz) / steps,

        srx = srx,
        sry = sry,
        srz = srz
      }
    end
  end

  if #_data <= 0 then return print('Camera: Unable to calculate path steps.') end

  SetIgnoreLookInput(true)
  SetIgnoreMoveInput(true)

  -- Set starting position
  local x, y, z, rx, ry, rz = path[1][1], path[1][2], path[1][3], path[1][4], path[1][5], path[1][6] 
  SetCameraLocation(x, y, z, true)
  SetCameraRotation(rx, ry, rz, true)

  CameraTimer = CreateTimer(Path_OnCameraTick, CameraTick, path, length, _data, steps)
  CameraState = CAMERA_ENABLED

  CallEvent('OnCameraStart', CAMERA_PATH)
end
AddFunctionExport('StartCameraPath', Path_StartCamera)

local function Path_OnStopCamera()
  if (CameraState == CAMERA_ENABLED and CameraTimer ~= 0) then
    DestroyTimer(CameraTimer)

    if not CameraStayInCamera then
      SetCameraLocation(0, 0, 0, false)
      SetCameraRotation(0, 0, 0, false)

      SetIgnoreLookInput(false)
      SetIgnoreMoveInput(false)
    end

    CallEvent('OnCameraStop', CAMERA_PATH)
  end
end
AddEvent('_OnStopCamera', Path_OnStopCamera)