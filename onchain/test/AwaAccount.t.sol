// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {MODULE_TYPE_EXECUTOR} from "@openzeppelin/contracts/interfaces/draft-IERC7579.sol";
import {
    ERC7579Utils,
    Mode,
    ModeSelector,
    ModePayload
} from "@openzeppelin/contracts/account/utils/draft-ERC7579Utils.sol";
import {AwaAccount} from "../src/AwaAccount.sol";
import {ExecutorModule} from "../src/ExecutorModule.sol";

contract AwaAccountTest is Test {
    AwaAccount public account;

    address _entryPoint;

    address immutable _OWNER = makeAddr("User EOA");
    ExecutorModule immutable _INIT_MODULE = new ExecutorModule();

    function setUp() public {
        account = new AwaAccount();
        _entryPoint = address(account.entryPoint());

        assertEq(account.signer(), address(this));
        account.initializeAccount(_OWNER, MODULE_TYPE_EXECUTOR, address(_INIT_MODULE), "");
        assertEq(account.signer(), _OWNER);
    }

    function test_RevertWhen_InvalidInitialization(address signer) public {
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        account.initializeAccount(signer, MODULE_TYPE_EXECUTOR, address(_INIT_MODULE), "");
    }

    function test_IncrementCount() public {
        vm.prank(_entryPoint);
        account.execute(
            Mode.unwrap(
                ERC7579Utils.encodeMode(
                    ERC7579Utils.CALLTYPE_SINGLE,
                    ERC7579Utils.EXECTYPE_DEFAULT,
                    ModeSelector.wrap(""),
                    ModePayload.wrap("")
                )
            ),
            abi.encodePacked(
                address(_INIT_MODULE), uint256(0), abi.encodeWithSelector(_INIT_MODULE.incrementCount.selector)
            )
        );

        vm.prank(address(account));
        assertEq(_INIT_MODULE.getCount(), 1);
    }

    function testFuzz_SetCount(uint256 x) public {
        vm.prank(_entryPoint);
        account.execute(
            Mode.unwrap(
                ERC7579Utils.encodeMode(
                    ERC7579Utils.CALLTYPE_SINGLE,
                    ERC7579Utils.EXECTYPE_DEFAULT,
                    ModeSelector.wrap(""),
                    ModePayload.wrap("")
                )
            ),
            abi.encodePacked(
                address(_INIT_MODULE), uint256(0), abi.encodeWithSelector(_INIT_MODULE.setCount.selector, x)
            )
        );

        vm.prank(address(account));
        assertEq(_INIT_MODULE.getCount(), x);
    }
}
