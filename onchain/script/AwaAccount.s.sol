// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {MODULE_TYPE_EXECUTOR} from "@openzeppelin/contracts/interfaces/draft-IERC7579.sol";
import {AwaAccount} from "../src/AwaAccount.sol";
import {ExecutorModuleScript} from "./ExecutorModule.s.sol";

contract AwaAccountScript is Script {
    AwaAccount public account;
    ExecutorModuleScript public moduleScript;

    address public owner;

    function setUp() public {
        moduleScript = new ExecutorModuleScript();
        owner = vm.promptAddress("User EOA");
    }

    function run() public {
        moduleScript.run();
        address moduleAddress = address(moduleScript.module());

        vm.startBroadcast();

        account = new AwaAccount();
        address accountAddress = address(account);

        account.initializeAccount(owner, MODULE_TYPE_EXECUTOR, moduleAddress, "");

        vm.stopBroadcast();

        console.log("Account Address:", accountAddress);
        console.log("Module Address:", moduleAddress);
        // Account Address: 0x13d07734f1dE5dF9D5B7a3C7e0Ab684aDd13fd9B
        // Module Address: 0xaCCB79680d6a24cda7c3c0F2EdC6AA3C627AEB74
    }
}
