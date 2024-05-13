/*
Track he current location of the player and the monsters
Track the updates to the locations of the player and the monsters
Implement special actions
Track the effects of special actions



Input:
clk, update_playerX (signed), update_playerY (signed), note


Output:
playerX (signed), playerY (signed), playerStatus


always @(posedge clk)
begin
	if (updated_playerX < 0 && playerX < MIN_PLAYER_X)
		playerX <= (playerX + update_playerX) + MAX_PLAYER_X;
	else
	begin
		if (updated_playerX > 0 && playerX > MAX_PLAYER_X)
			playerX <= (playerX + update_playerX) + MIN_PLAYER_X;
		else
			playerX <= playerX + update_playerX;
	end
	
	if (updated_playerY < 0 && playerY < MIN_PLAYER_Y)
		playerX <= (playerY + update_playerY) + MAX_PLAYER_Y;
	else
	begin
		if (updated_playerY > 0 && playerY > MAX_PLAYER_Y)
			playerX <= (playerY + update_playerY) + MIN_PLAYER_Y;
		else
			playerX <= playerY + update_playerY;
	end
end
*/