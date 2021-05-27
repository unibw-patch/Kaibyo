package com.dat3m.ui.options.utils;

public enum ControlCode {

    TARGET, BOUND, TEST, CLEAR;

    @Override
    public String toString(){
        switch(this){
            case TARGET:
                return "Target";
            case BOUND:
                return "Bound";
            case TEST:
                return "Test";
            case CLEAR:
                return "Clear";
        }
        return super.toString();
    }

    public String actionCommand(){
        switch(this){
            case TARGET:
                return "control_command_target";
            case BOUND:
                return "control_command_bound";
            case TEST:
                return "control_command_test";
            case CLEAR:
                return "control_command_clear";
        }
        throw new RuntimeException("Illegal EditorCode");
    }
}
