// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {MODULE_TYPE_EXECUTOR} from "@openzeppelin/contracts/interfaces/draft-IERC7579.sol";
import {
    ERC7579Utils,
    Execution,
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

    function test_RevertWhen_ERC7579AlreadyInstalledModule() public {
        address initModule = address(_INIT_MODULE);
        bytes memory erc7579AlreadyInstalledModule = abi.encodeWithSelector(
            ERC7579Utils.ERC7579AlreadyInstalledModule.selector, MODULE_TYPE_EXECUTOR, initModule
        );

        vm.prank(_entryPoint);
        vm.expectRevert(erc7579AlreadyInstalledModule);
        account.installModule(MODULE_TYPE_EXECUTOR, initModule, "");
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

    function testFuzz_ExecuteBatch(uint8 count) public {
        Execution memory incrementCount = Execution({
            target: address(_INIT_MODULE),
            value: 0,
            callData: abi.encodeWithSelector(_INIT_MODULE.incrementCount.selector)
        });

        Execution[] memory batch = new Execution[](count);
        for (uint8 a = 0; a < count; a++) {
            batch[a] = incrementCount;
        }

        vm.prank(_entryPoint);
        account.execute(
            Mode.unwrap(
                ERC7579Utils.encodeMode(
                    ERC7579Utils.CALLTYPE_BATCH,
                    ERC7579Utils.EXECTYPE_DEFAULT,
                    ModeSelector.wrap(""),
                    ModePayload.wrap("")
                )
            ),
            ERC7579Utils.encodeBatch(batch)
        );

        vm.prank(address(account));
        assertEq(_INIT_MODULE.getCount(), count);
    }
}
