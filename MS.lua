
local MainSlider = Main:CreateSlider({
    Name = "Mag Range",
    Range = {0, 25},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 18,
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(maxdistance)
        local lp = game:GetService("Players").LocalPlayer
        local stepped = game:GetService("RunService").Stepped
        local user = game:GetService("UserInputService")
        local gui = game:GetService("GuiService")
         
        local maxdistance = 15 --Max distance you can catch a football from, server caps it at some point anyways
        local autoclickoffset = nil --How far off from the max distance to click, nil for no auto
         
        local escmenu = false
         
        autoclickoffset = autoclickoffset and autoclickoffset + maxdistance
         
        local infinite = math.huge
        local workspace = workspace
        local firetouchinterest = firetouchinterest
        local FindFirstChild = game.FindFirstChild
        local FindFirstChildOfClass = game.FindFirstChildOfClass
        local task = task
        local connect = stepped.Connect
        local waitfor = stepped.Wait
        local keypress = keypress
        local keyrelease = keyrelease
        local gettextbox = user.GetFocusedTextBox
        local pairs = pairs
         
        local catchparts = {
           "CatchRight",
           "CatchLeft"
        }
         
        local function resolveShortest(ball, charac)
           local shortest, chosen = infinite, nil
         
           for i, name in pairs(catchparts) do
               local part = FindFirstChild(charac, name)
               local dist = part and (part.Position - ball.Position).Magnitude or infinite
         
               if dist < shortest then
                   shortest = dist
                   chosen = part
               end
           end
         
           return shortest, chosen
        end
         
        local function WaitForChildOfClass(inst, child, maxtime)
           local timer = 0
           maxtime = maxtime or infinite
         
           local found = FindFirstChildOfClass(inst, child)
           while not found and timer < maxtime do
               timer = timer + task.wait()
               found = FindFirstChildOfClass(inst, child)
         
               if found then
                   return found
               end
           end
         
           return found
        end
         
        connect(gui.MenuOpened, function()
           escmenu = true
        end)
         
        connect(gui.MenuClosed, function()
           escmenu = false
        end)
         
        connect(workspace.ChildAdded, function(ball)
           if ball.Name == "Football" and WaitForChildOfClass(ball, "TouchTransmitter", 3) then
               local charac = lp.Character
         
               while ball.Parent == workspace and charac do
                   local dist, part = resolveShortest(ball, charac)
         
                   if part then
                       if autoclickoffset and dist <= autoclickoffset and not (gettextbox(user) or escmenu) then
                           keypress(0x43) --C key, not mouse click cus that can do gay shit like close out roblox
                           keyrelease(0x43)
                       end
         
                       if dist <= maxdistance then
                           firetouchinterest(part, ball, 1)
                           firetouchinterest(part, ball, 0)
                       end
                   end
         
                   waitfor(stepped)
               end
           end
        end)
    -- The variable (Value) is a number which correlates to the value the slider is currently at
    end,
 })















