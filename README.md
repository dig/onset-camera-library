# onset-camera-library
Authors: Digital

### Features
* Set camera to pan a location.
* Set camera on paths.

### Installation
Create a folder inside your servers package folder called camera, download all files from this repository and place them inside the camera folder. <br />
Edit your server_config.json to install camera as a package.

### Example
```lua
local Camera = ImportPackage('camera')

-- Start camera panning over the quarry
Camera.StartCameraPan({ -98067, 93583, 400 }, 15000, 0.05, { 0, 0, 7000 })

-- Start camera path near the prison
Camera.StartCameraPath({
  { -157745.265625, 76728.546875, 2211.7468261719, 351.61010742188, 155.78399658203, 0.0 },
  { -160801.359375, 78152.84375, 1891.3470458984, 359.83453369141, 180.45664978027, 0.0 },
  { -163122.6875, 78130.640625, 2388.2092285156, 3.4768590927124, 182.0550994873, 0.0 },
  { -167719.71875, 77846.765625, 2019.0693359375, 356.47750854492, 179.95524597168, 0.0 }
}, 5000)

-- Print if camera is enabled or not
AddPlayerChat(tostring(Camera.IsCameraEnabled()))

-- Stop camera
Camera.StopCamera()
```

### Functions
#### StartCameraPan
Start the camera panning over a center point.
```lua
Camera.StartCameraPan(center, distance, speed, [, offset], [, stayInCamera])
```
* **center** Array with 3 entries, x, y, z. Example: { -98067, 93583, 400 }
* **distance** Camera distance from center point. Example: 15000
* **speed** Speed of the camera. Example: 0.05
* **offset (optional)** Offset to the camera position. Example: { 0, 0, 7000 }
* **stayInCamera (optional)** Default false, if true the camera will not return to the player after the pan ends.

#### StartCameraPath
Start the camera following a path.
```lua
Camera.StartCameraPath(path, length, [, stayInCamera])
```
* **path** Table with position arrays inside. Each array must contain 6 entries, x, y, z, rx, ry, rz. r being rotation. Format for each array should be { x, y, z, rx, ry, rz }. Example: See above
* **length** How long the camera will follow the path for in milliseconds. Example: 5000
* **stayInCamera (optional)** Default false, if true the camera will not return to the player after the path ends.

#### StopCamera
Stop the camera.
```lua
Camera.StopCamera()
```

#### IsCameraEnabled
Returns if the camera is currently enabled.
```lua
Camera.IsCameraEnabled()
```
Return boolean.
