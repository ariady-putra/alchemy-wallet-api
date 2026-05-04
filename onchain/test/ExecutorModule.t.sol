// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ExecutorModule} from "../src/ExecutorModule.sol";

contract ExecutorModuleTest is Test {
    ExecutorModule public module;

    function setUp() public {
        module = new ExecutorModule();
    }

    function test_IncrementCount() public {
        module.incrementCount();
        assertEq(module.getCount(), 1);
    }

    function testFuzz_SetCount(uint256 x) public {
        module.setCount(x);
        assertEq(module.getCount(), x);
    }
}
