package com.dat3m.ui.utils;

import com.dat3m.dartagnan.utils.Settings;

public class UiOptions {

	private final Settings settings;
	private final String entry;
	private final String secret;
	private boolean enable_branch_speculation;
	private boolean only_branch_speculation_leak;
	private int timeout;

	public UiOptions(Settings settings, int timeout, String entry, String secret, boolean enable_branch_speculation, boolean only_branch_speculation_leak) {
		this.settings = settings;
		this.timeout = timeout;
		this.entry = entry;
		this.secret = secret;
		this.enable_branch_speculation = enable_branch_speculation;
		this.only_branch_speculation_leak = only_branch_speculation_leak ;
	}
	
	public int getTimeout() {
		return timeout;
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
