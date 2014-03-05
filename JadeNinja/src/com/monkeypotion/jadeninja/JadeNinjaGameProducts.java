package com.monkeypotion.jadeninja;

import java.util.HashSet;
import java.util.Set;

import com.studioirregular.gaoframework.GameProducts;

public class JadeNinjaGameProducts implements GameProducts {

	private Set<String> ConsumableGameProducts = new HashSet<String>();
	private Set<String> NonConsumableGameProducts = new HashSet<String>();
	
	public JadeNinjaGameProducts() {
		
		ConsumableGameProducts.add("com.monkeypotion.jadeninja.newkoban1");
		ConsumableGameProducts.add("com.monkeypotion.jadeninja.newkoban2");
		ConsumableGameProducts.add("com.monkeypotion.jadeninja.newkoban3");
		ConsumableGameProducts.add("com.monkeypotion.jadeninja.newkoban4");
		
		NonConsumableGameProducts.add("com.monkeypotion.jadeninja.starterkit");
		NonConsumableGameProducts.add("com.monkeypotion.jadeninja.avatar1");
		NonConsumableGameProducts.add("com.monkeypotion.jadeninja.avatar2");
		NonConsumableGameProducts.add("com.monkeypotion.jadeninja.jade1");
	}
	
	@Override
	public boolean isConsumable(String id) {
		return ConsumableGameProducts.contains(id);
	}
	
	@Override
	public boolean consumeRightAfterBought(String id) {
		// All consumable product are gold, and should be consumed after bought.
		return ConsumableGameProducts.contains(id);
	}
}
