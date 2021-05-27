package com.dat3m.ui.utils;

import com.dat3m.dartagnan.utils.Settings;

public class UiOptions {

	private final Settings settings;
	private final String entry;
	private final String secret;


	public UiOptions(Settings settings, String entry, String secret) {
		this.settings = settings;
		this.entry = entry;
		this.secret = secret;
	}
	
	public String getEntry() {
		return entry;
	}

	public String getSecret() {
		return secret;
	}

	public Settings getSettings(){
		return settings;
	}
}
