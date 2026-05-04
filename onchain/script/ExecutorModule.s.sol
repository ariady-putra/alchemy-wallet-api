// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
import {ExecutorModule} from "../src/ExecutorModule.sol";

contract ExecutorModuleScript is Script {
    ExecutorModule public module;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        module = new ExecutorModule();

        vm.stopBroadcast();
    }
}
