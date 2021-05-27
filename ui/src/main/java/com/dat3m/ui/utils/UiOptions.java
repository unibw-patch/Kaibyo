package com.dat3m.ui.utils;

import com.dat3m.dartagnan.utils.Settings;

public class UiOptions {

	private final Settings settings;
	private final String entry;


	public UiOptions(Settings settings, String entry) {
		this.settings = settings;
		this.entry = entry;
	}
	
	public String getEntry() {
		return entry;
	}

	public Settings getSettings(){
		return settings;
	}
}
