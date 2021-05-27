package com.dat3m.ui.utils;

import com.dat3m.dartagnan.utils.Settings;

public class UiOptions {

	private final Settings settings;
	private final String entry;
	private final String secret;
	private boolean enable_branch_speculation;
	private boolean only_branch_speculation_leak;


	public UiOptions(Settings settings, String entry, String secret, boolean enable_branch_speculation, boolean only_branch_speculation_leak) {
		this.settings = settings;
		this.entry = entry;
		this.secret = secret;
		this.enable_branch_speculation = enable_branch_speculation;
		this.only_branch_speculation_leak = only_branch_speculation_leak ;
	}
	
	public String getEntry() {
		return entry;
	}

	public String getSecret() {
		return secret;
	}

	public boolean speculate() {
		return enable_branch_speculation;
	}

	public boolean specLeak() {
		return only_branch_speculation_leak;
	}

	public Settings getSettings(){
		return settings;
	}
}
