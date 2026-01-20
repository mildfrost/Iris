## USAGE
Request and loadstring Loader.luau. Use Iris like normal.
```lua
local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/mildfrost/Iris/refs/heads/master/Loader.luau"))()
Iris = Iris.Init()
```

For more infomation on Iris, refer to Iris's official page: https://github.com/SirMallard/Iris

## Source code changes to Iris (in the rbxm) 
Required icons are requested from here, saved, and loaded with ```getcustomasset()```, since the ones Iris use are only accessible in Roblox Studio.  
Made ```gethui()``` a compatible parent for Iris.  
```Iris.Init()```'s first parameter (```parentInstance```) is defaulted to ```gethui()```.

## What does the loader do?
I made the loader so I don't have to manually put all the code of the modules together. I wanted to keep changes to the source of Iris at a minimal. (This was thought about and made in a few hours, please dont call me stupid if there's a better solution 😭) 

The loader requests Iris's rbxm from here, saves it, creates a fake asset id using ```getcustomasset()```, loads it using ```game:GetObjects()```, and finally, requires it using ```CustomRequire()```, since you cannot create a modulescript and ```require()``` it like usual.  

Since the code under ```ModuleScript.Source``` doesn't function as a normal modulescript in-game (it will pretty much just hold text), this means is that we will need to use ```loadstring()``` to make it a usable function. 
Since we have to convert it into usable code using ```loadstring()``` in our exploit, the ```script``` global will be evaluated under the context of the exploit, this will return nil.  
The ```script``` global is necessary to refer to the module's children from within the modulescript, so we need to use a custom ```require()``` function.  

```CustomRequire()``` first adds ```local script = [Module's Path]``` to the module's source, which will shadow the global ```script```. This is so when any of the modules use ```script``` to refer to itself, it actually returns the module.
Then, it creates the function from this source using ```loadstring()```, which essentially just acts as the module script and calling it acts the same as requiring it.    
Next, it changes ```require()``` in the function's environment to ```CustomRequire()```, so any ```require()``` within the function will work as well. 
Finally, it will call the function returned by ```loadstring()``` and return its value, eventually returning Iris.
