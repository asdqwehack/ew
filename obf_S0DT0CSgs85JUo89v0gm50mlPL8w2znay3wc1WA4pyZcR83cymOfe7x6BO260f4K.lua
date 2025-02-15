local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local targetPlayerName = ""
local isActive = false
local isMinimized = false

local function executeCommand(command)
    local targetCharacter = character
    if not targetCharacter then return end

    if command == "Left face." then
        targetCharacter:SetPrimaryPartCFrame(targetCharacter.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(90), 0))
    elseif command == "Right face." then
        targetCharacter:SetPrimaryPartCFrame(targetCharacter.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-90), 0))
    elseif command == "Center face." then
        local currentPos = targetCharacter.PrimaryPart.Position
        local cameraLookVector = workspace.CurrentCamera.CFrame.LookVector
        local targetLookVector = Vector3.new(cameraLookVector.X, 0, cameraLookVector.Z).Unit
        targetCharacter:SetPrimaryPartCFrame(CFrame.new(currentPos, currentPos + targetLookVector))
    elseif command == "Left incline." then
        targetCharacter:SetPrimaryPartCFrame(targetCharacter.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(45), 0))
    elseif command == "Right incline." then
        targetCharacter:SetPrimaryPartCFrame(targetCharacter.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-45), 0))
    elseif command == "About face." then
        targetCharacter:SetPrimaryPartCFrame(targetCharacter.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(180), 0))
    end
end

local function onChatMessage(newPlayer, message)
    if newPlayer.Name == targetPlayerName and isActive and not string.match(message, "^/team ") then
        wait(0.8)
        executeCommand(message)
    end
end

local function createModernUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CommandUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 144, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 206, 235))
    })
    gradient.Rotation = 45
    gradient.Parent = mainFrame

    local gradientTween = TweenService:Create(gradient, TweenInfo.new(
        3,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Rotation = 225
    })
    gradientTween:Play()

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    titleBar.BackgroundTransparency = 0.5
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "밥밥부대 자동 시험"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0, 5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 20
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = mainFrame

    local function addCorner(button)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
    end

    addCorner(closeButton)
    addCorner(minimizeButton)

    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, 0, 1, -40)
    contentContainer.Position = UDim2.new(0, 0, 0, 40)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0.9, 0, 0, 45)
    inputFrame.Position = UDim2.new(0.05, 0, 0, 20)
    inputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    inputFrame.BackgroundTransparency = 0.2
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = contentContainer

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputFrame

    local targetInput = Instance.new("TextBox")
    targetInput.Size = UDim2.new(0.9, 0, 0.8, 0)
    targetInput.Position = UDim2.new(0.05, 0, 0.1, 0)
    targetInput.BackgroundTransparency = 1
    targetInput.Text = ""
    targetInput.PlaceholderText = "타겟 플레이어 이름"
    targetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
    targetInput.TextSize = 16
    targetInput.Font = Enum.Font.GothamMedium
    targetInput.Parent = inputFrame

    local function autocompletePlayerName()
        local inputText = targetInput.Text:lower()
        if #inputText >= 3 then  
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Name:lower():sub(1, #inputText) == inputText then
                    targetInput.Text = player.Name
                    targetInput.CursorPosition = #player.Name + 1
                    return
                end
            end
        end
    end

    targetInput:GetPropertyChangedSignal("Text"):Connect(autocompletePlayerName)

    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(0.9, 0, 0, 40)
    statusFrame.Position = UDim2.new(0.05, 0, 0, 80)
    statusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    statusFrame.BackgroundTransparency = 0.2
    statusFrame.BorderSizePixel = 0
    statusFrame.Parent = contentContainer

    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = statusFrame

    local statusIndicator = Instance.new("Frame")
    statusIndicator.Size = UDim2.new(0, 12, 0, 12)
    statusIndicator.Position = UDim2.new(0.05, 0, 0.5, -6)
    statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    statusIndicator.Parent = statusFrame

    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = statusIndicator

    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0.8, 0, 1, 0)
    statusText.Position = UDim2.new(0.15, 0, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "비활성화"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamMedium
    statusText.Parent = statusFrame

    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(0.9, 0, 0, 45)
    buttonContainer.Position = UDim2.new(0.05, 0, 0, 135)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = contentContainer

    local onButton = Instance.new("TextButton")
    onButton.Size = UDim2.new(0.48, 0, 1, 0)
    onButton.Position = UDim2.new(0, 0, 0, 0)
    onButton.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
    onButton.Text = "활성화"
    onButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    onButton.TextSize = 16
    onButton.Font = Enum.Font.GothamBold
    onButton.Parent = buttonContainer

    local onCorner = Instance.new("UICorner")
    onCorner.CornerRadius = UDim.new(0, 8)
    onCorner.Parent = onButton

    local offButton = Instance.new("TextButton")
    offButton.Size = UDim2.new(0.48, 0, 1, 0)
    offButton.Position = UDim2.new(0.52, 0, 0, 0)
    offButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    offButton.Text = "비활성화"
    offButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    offButton.TextSize = 16
    offButton.Font = Enum.Font.GothamBold
    offButton.Parent = buttonContainer

    local offCorner = Instance.new("UICorner")
    offCorner.CornerRadius = UDim.new(0, 8)
    offCorner.Parent = offButton

    local dragging = false
    local dragStart = nil
    local startPos = nil
    local dragInput = nil

    local function updateDrag(input)
        local delta = input.Position - dragStart
        local targetPosition = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

        TweenService:Create(mainFrame, TweenInfo.new(0.1), {
            Position = targetPosition
        }):Play()
    end

    mainFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch) and
            input.Position.Y - mainFrame.AbsolutePosition.Y <= 40 then

            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)

    local function createButtonEffect(button)
        local originalColor = button.BackgroundColor3
        local originalSize = button.Size
        local originalPosition = button.Position
        local isShrunk = false

        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = originalColor:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
            }):Play()
        end)

        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = originalColor
            }):Play()
        end)

        button.MouseButton1Down:Connect(function()
            if not isShrunk then
                isShrunk = true
                TweenService:Create(button, TweenInfo.new(0.1), {
                    Size = originalSize - UDim2.new(0, 4, 0, 4),
                    Position = originalPosition + UDim2.new(0, 2, 0, 2)
                }):Play()
            end
        end)

        button.MouseButton1Up:Connect(function()
            if isShrunk then
                isShrunk = false
                TweenService:Create(button, TweenInfo.new(0.1), {
                    Size = originalSize,
                    Position = originalPosition
                }):Play()
            end
        end)
    end

    createButtonEffect(onButton)
    createButtonEffect(offButton)

    local originalSize = UDim2.new(0, 350, 0, 250)
    local originalPos = mainFrame.Position

    closeButton.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset + 175, 
                                mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + 125)
        }):Play()
        
        wait(0.3)
        screenGui:Destroy()
    end)

    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
    
        if isMinimized then
            originalPos = mainFrame.Position
            
            contentContainer.Visible = false
            
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 350, 0, 40),
                Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, originalPos.Y.Scale, originalPos.Y.Offset + 105)
            }):Play()
        
            TweenService:Create(minimizeButton, TweenInfo.new(0.3), {
                Rotation = 180
            }):Play()
            minimizeButton.Text = "+"
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
                Size = originalSize,
                Position = originalPos
            }):Play()
            
            wait(0.2)
            
            contentContainer.Visible = true
            
            TweenService:Create(minimizeButton, TweenInfo.new(0.3), {
                Rotation = 0
            }):Play()
            minimizeButton.Text = "-"
        end
    end)

    onButton.MouseButton1Click:Connect(function()
        targetPlayerName = targetInput.Text
        isActive = true
        statusIndicator.BackgroundColor3 = Color3.fromRGB(45, 200, 75)
        statusText.Text = "활성화됨: " .. targetPlayerName

        local flash = Instance.new("Frame")
        flash.Size = UDim2.new(1, 0, 1, 0)
        flash.BackgroundColor3 = Color3.fromRGB(45, 200, 75)
        flash.BackgroundTransparency = 0
        flash.Parent = statusFrame

        local flashCorner = Instance.new("UICorner")
        flashCorner.CornerRadius = UDim.new(0, 8)
        flashCorner.Parent = flash

        TweenService:Create(flash, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()

        game.Debris:AddItem(flash, 0.5)
    end)

    offButton.MouseButton1Click:Connect(function()
        isActive = false
        statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
        statusText.Text = "비활성화됨"

        local flash = Instance.new("Frame")
        flash.Size = UDim2.new(1, 0, 1, 0)
        flash.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
        flash.BackgroundTransparency = 0
        flash.Parent = statusFrame

        local flashCorner = Instance.new("UICorner")
        flashCorner.CornerRadius = UDim.new(0, 8)
        flashCorner.Parent = flash

        TweenService:Create(flash, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()

        game.Debris:AddItem(flash, 0.5)
    end)
end

game.Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.Chatted:Connect(function(message)
        onChatMessage(newPlayer, message)
    end)
end)

for _, existingPlayer in ipairs(game.Players:GetPlayers()) do
    existingPlayer.Chatted:Connect(function(message)
        onChatMessage(existingPlayer, message)
    end)
end

createModernUI()




