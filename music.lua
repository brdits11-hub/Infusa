-- Coloque este Script em ServerScriptService

local SoundService = game:GetService("SoundService")

local sound = Instance.new("Sound")
sound.Name = "MusicPlayer"
sound.Volume = 1
sound.Looped = true
sound.Parent = SoundService

local MUSIC_ID = "rbxassetid://1234567890" -- coloque o ID aqui

sound.SoundId = MUSIC_ID
sound:Play()
