local mps = game:GetService("MarketplaceService")
local frame = game.Players.LocalPlayer.PlayerGui:WaitForChild("item checker").Frame
local itemframe = game.ReplicatedStorage.Item
local itemsframe = game.Players.LocalPlayer.PlayerGui:WaitForChild("item checker").ItemList
local openitems = game.Players.LocalPlayer.PlayerGui:WaitForChild("item checker").openitems

openitems.Activated:Connect(function()
	itemsframe.Visible = not itemsframe.Visible
end)

frame.TextButton.MouseButton1Click:Connect(function()
	local id = frame.TextBox.Text
	local success, result = pcall(function()
		mps:GetProductInfo(id,Enum.InfoType.Asset)
	end)
	
	if success and not itemsframe.ScrollingFrame:FindFirstChild(id) then
		local clone = itemframe:Clone()
		clone.Name = id
		clone.Parent = itemsframe.ScrollingFrame
		
		local active = true
		local retries = 0

		local fd
		repeat
			local success2, _ = pcall(function()
				fd = mps:GetProductInfo(id,Enum.InfoType.Asset)
			end)
		until success2
		print(fd)
		clone.ItemName.Text = fd.Name
		
		clone.Close.Activated:Connect(function()
			if active then active = not active end
		end)
		
		while active do
			retries += 1
			local data
			local success2, _ = pcall(function()
				data = mps:GetProductInfo(id,Enum.InfoType.Asset)
			end)
			if success and data then
				if data.IsForSale == true then
					mps:PromptPurchase(game.Players.LocalPlayer,id)
					workspace["Fire Alarm High School Harsh Rhythmic Buzzer (SFX)"]:Play()
					repeat
						local success2, _ = pcall(function()
							data = mps:GetProductInfo(id,Enum.InfoType.Asset)
						end)
						mps:PromptPurchase(game.Players.LocalPlayer,id)
					until data.Remaining <= 0 or active == false
					break
				else
					print("no")
					clone.retries.Text = "Retries: "..retries
				end
			end
		end
		clone:Destroy()
	elseif itemsframe.ScrollingFrame:FindFirstChild(id) then
		frame.TextBox.Text = ""
		frame.TextBox.PlaceholderText = "dummie its already there"
		wait(2)
	elseif not success then
		frame.TextBox.Text = ""
		frame.TextBox.PlaceholderText = "Error while trying to put id, try again"
		wait(2)
	end
	frame.TextButton.Text = "Start"
	frame.TextBox.PlaceholderText = "ITEM IDE HERE XD!"
	frame.TextButton.BackgroundColor3 = Color3.fromRGB(223, 223, 223)
	frame.retries.Text = ""
end)
