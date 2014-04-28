--***********************************************************************
-- @file GameMoney.lua
--***********************************************************************

-------------------------------------------------------------------------
MoneyManager =
{
    m_Coin = 0,
    m_Koban = 0,
    m_CoinObservers = nil,
    m_KobanObservers = nil,
    
	---------------------------------------------------------------------
    Create = function(self)
        self.m_CoinObservers =
        {
            "EndlessMap", "Shop", "ScrollSelect", "TreasureSelect", "GameStat", "InGame",
        };

        self.m_KobanObservers =
        {
            "EndlessMap", "Shop", "ScrollSelect", "TreasureSelect", "GameStat",
        };

		local coin = IOManager:GetValue(IO_CAT_HACK, "Money", "Coin");
		assert(coin >= 0, "Coin error: " .. coin);
		local koban = IOManager:GetValue(IO_CAT_HACK, "Money", "Koban");
		assert(koban >= 0, "Koban error: " .. koban);

        self:SetCoin(coin);
        self:SetKoban(koban);

		log("MoneyManager creation done");
		--log("  => Coin  : "..coin)
		--log("  => Koban : "..koban)
    end,
	---------------------------------------------------------------------
    ResetMotion = function(self, ui)
		local gc = UIManager:GetWidgetComponent(ui, "CoinNum", "Interpolator");
		if (gc:IsOnInterpolating()) then
			gc:SetEnd();
		end

		local gc = UIManager:GetWidgetComponent(ui, "KobanNum", "Interpolator");
		if (gc:IsOnInterpolating()) then
			gc:SetEnd();
		end
    end,
	---------------------------------------------------------------------
	UpdateCoinNum = function(self, coin)
        for _, ui in ipairs(self.m_CoinObservers) do
            UIManager:GetWidget(ui, "CoinNum"):SetValue(coin);
        end
	end,
	---------------------------------------------------------------------
	UpdateKobanNum = function(self, koban)
        for _, ui in ipairs(self.m_KobanObservers) do
			UIManager:GetWidget(ui, "KobanNum"):SetValue(koban);
        end
	end,
	---------------------------------------------------------------------
    SetCoin = function(self, coin)
		if (coin < 0) then
			log("SetCoin error: "..coin);
			coin = 0;
		end
		
        self.m_Coin = coin;
		IOManager:SetValue(IO_CAT_HACK, "Money", "Coin", coin);
		self:UpdateCoinNum(coin);
    end,
	---------------------------------------------------------------------
    SetKoban = function(self, koban, doSave)
		if (koban < 0) then
--[[ @DEBUG
			local str = "SetKoban error: "..koban.." / [bank] "..self.m_Koban;
			log(str);
			GameKit.ShowMessage("debug", str);
--]]			
			log("SetKoban error: "..coin);
			koban = 0;
		end

        self.m_Koban = koban;
		IOManager:SetValue(IO_CAT_HACK, "Money", "Koban", koban, doSave);
		self:UpdateKobanNum(koban);
    end,
	---------------------------------------------------------------------
    GetCoin = function(self)
        return self.m_Coin;
    end,
	---------------------------------------------------------------------
    GetKoban = function(self)
        return self.m_Koban;
    end,
	---------------------------------------------------------------------
    ModifyCoin = function(self, coin)
	    --log("ModifyCoin: ".. coin .." => " .. self.m_Coin + coin);
		self:UpdateTimeStamp();
		self:SetCoin(self.m_Coin + coin);
    end,
	---------------------------------------------------------------------
    ModifyKoban = function(self, koban, doSave)
	    --log("ModifyKoban: " .. koban .. " => " .. self.m_Koban + koban);
		self:UpdateTimeStamp();
		self:SetKoban(self.m_Koban + koban, doSave);
    end,
	---------------------------------------------------------------------
    ModifyCoinWithMotion = function(self, coin, ui)
		assert(ui, "ModifyCoinWithMotion error");
		assert(self.m_Coin + coin >= 0, "ModifyCoinWithMotion error: [self] "..self.m_Coin.." [mod] "..coin);
		
		self:ResetMotion(ui);
    
        local gc = UIManager:GetWidgetComponent(ui, "CoinNum", "Interpolator");
    	gc:AttachUpdateCallback(SetCoinNum);
		gc:AppendNextTarget(self.m_Coin, self.m_Coin + coin, 500);
		
		UIManager:GetWidgetComponent(ui, "CoinNum", "Transform"):SetTranslateEx(UI_COIN_POS);
		local motionGC = UIManager:GetWidgetComponent(ui, "CoinNum", "Motion");
		motionGC:ResetTarget(UI_COIN_POS[1], UI_COIN_POS[2] + 5);
		motionGC:AppendNextTarget(UI_COIN_POS[1], UI_COIN_POS[2]);

	    --log("ModifyCoinWithMotion: "..coin.." => "..self.m_Coin + coin)
        self.m_Coin = self.m_Coin + coin;
		IOManager:SetValue(IO_CAT_HACK, "Money", "Coin", self.m_Coin);
		
		self:UpdateTimeStamp();
    end,
	---------------------------------------------------------------------
	ModifyKobanWithMotion = function(self, koban, ui)
		assert(ui, "ModifyKobanWithMotion error");
		assert(self.m_Koban + koban >= 0, "ModifyKobanWithMotion error: [self] "..self.m_Koban.." [mod] "..koban);

		self:ResetMotion(ui);
    
        local gc = UIManager:GetWidgetComponent(ui, "KobanNum", "Interpolator");
    	gc:AttachUpdateCallback(SetKobanNum);
		gc:AppendNextTarget(self.m_Koban, self.m_Koban + koban, 500);

		UIManager:GetWidgetComponent(ui, "KobanNum", "Transform"):SetTranslateEx(UI_KOBAN_POS);
		local motionGC = UIManager:GetWidgetComponent(ui, "KobanNum", "Motion");
		motionGC:ResetTarget(UI_KOBAN_POS[1], UI_KOBAN_POS[2] + 5);
		motionGC:AppendNextTarget(UI_KOBAN_POS[1], UI_KOBAN_POS[2]);

	    --log("ModifyKobanWithMotion: "..koban.." => "..self.m_Koban + koban)
        self.m_Koban = self.m_Koban + koban;
		IOManager:SetValue(IO_CAT_HACK, "Money", "Koban", self.m_Koban);
		
		self:UpdateTimeStamp();
    end,
--[[ @BoostByCoin
	---------------------------------------------------------------------
    ModifyCoinWithMotionInGame = function(self, coin)
		assert(self.m_Coin + coin >= 0, "ModifyCoinWithMotionInGame error: [self] "..self.m_Coin.." [mod] "..coin);
    
        local gc = UIManager:GetWidgetComponent("InGame", "CoinNum", "Interpolator");
    	gc:AttachUpdateCallback(SetCoinNum);
		gc:AppendNextTarget(self.m_Coin, self.m_Coin + coin, 500);
		
		UIManager:GetWidgetComponent("InGame", "CoinNum", "Transform"):SetTranslateEx(UI_INGAME_COIN_ORIGIN);
		local motionGC = UIManager:GetWidgetComponent("InGame", "CoinNum", "Motion");
		motionGC:ResetTarget(UI_INGAME_COIN_ORIGIN[1], UI_INGAME_COIN_ORIGIN[2] + 5);
		motionGC:AppendNextTarget(UI_INGAME_COIN_ORIGIN[1], UI_INGAME_COIN_ORIGIN[2]);

        self.m_Coin = self.m_Coin + coin;
		IOManager:SetValue(IO_CAT_HACK, "Money", "Coin", self.m_Coin, true);
    end,
--]]
	---------------------------------------------------------------------
    HasEnoughCoin = function(self, coin)
        if ((self.m_Coin > 0) and (self.m_Coin >= coin)) then
			--log("Has Enough: [self] "..self.m_Coin.." [mod] "..coin);
            return true;
        end
		--log("Not Enough: [self] "..self.m_Coin.." [mod] "..coin);
        return false;
    end,
	---------------------------------------------------------------------
    HasEnoughKoban = function(self, koban)
        if ((self.m_Koban > 0) and (self.m_Koban >= koban)) then
            return true;
        end
        return false;
    end,
	---------------------------------------------------------------------
	UpdateTimeStamp = function(self)	
		IOManager:SetValue(IO_CAT_HACK, "Money", "TimeStamp", math.floor(GameKit.GetCurrentSystemTime()));
	end,
};

-------------------------------------------------------------------------
function SetCoinNum(coin)
	MoneyManager:UpdateCoinNum(coin);
end

-------------------------------------------------------------------------
function SetKobanNum(koban)
	MoneyManager:UpdateKobanNum(koban);
end
