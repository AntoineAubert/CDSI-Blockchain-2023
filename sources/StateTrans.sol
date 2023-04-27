// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title StateTrans
 * @dev State transaction based on time
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract StateTrans {

    enum Stage {Init, Reg, Vote, Done}
    Stage public stage;
    uint startTime;
    uint public timeNow;
    
    /**
     * @dev Constructor of the StateTrans
     */
    constructor() {
        stage = Stage.Init;
        startTime = block.timestamp;
    }
    
    //Assuming the Stage change has to be enacted APPROX every 10 seconds
    //timeNow variable is defined for underatanding the process, you can simply use 
    // "block.timestamp" (the current time) Solidity defined varaible 
    // Of course, time duration for the Stages may depend on your application
    //10 seconds is set to illustrate the working 
    /**
     * @dev Advances the system state if the time is elapsed
     */
    function advanceState () public  {
        timeNow = block.timestamp;
        if (timeNow > (startTime + 10 seconds)) {
        startTime = timeNow;  
        if (stage == Stage.Init) {stage = Stage.Reg; return;}
        if (stage == Stage.Reg) {stage = Stage.Vote; return;}
        if (stage == Stage.Vote) {stage = Stage.Done; return;}
        return;
        }
    }
}