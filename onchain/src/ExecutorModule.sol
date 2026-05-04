// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC7579Executor} from "@openzeppelin/community-contracts/account/modules/ERC7579Executor.sol";
import {IERC7579Module} from "@openzeppelin/contracts/interfaces/draft-IERC7579.sol";

type Owner is address;
type Count is uint256;

contract ExecutorModule is ERC7579Executor {
    mapping(Owner => Count) private _ownerCount;

    function getCount() public view virtual returns (uint256) {
        return Count.unwrap(_ownerCount[Owner.wrap(msg.sender)]);
    }

    function setCount(uint256 count) public virtual {
        _ownerCount[Owner.wrap(msg.sender)] = Count.wrap(count);
    }

    function resetCount() public virtual {
        setCount(0);
    }

    function incrementCount() public virtual returns (uint256) {
        uint256 updatedCount = getCount() + 1;
        setCount(updatedCount);
        return updatedCount;
    }

    function decrementCount() public virtual returns (uint256) {
        uint256 updatedCount = getCount() - 1;
        setCount(updatedCount);
        return updatedCount;
    }

    /// @inheritdoc ERC7579Executor
    function _validateExecution(address account, bytes32 salt, bytes32 mode, bytes calldata data)
        internal
        virtual
        override
        returns (bytes calldata)
    {
        return data;
    }

    /// @inheritdoc IERC7579Module
    function onInstall(bytes calldata data) external {}

    /// @inheritdoc IERC7579Module
    function onUninstall(bytes calldata data) external {
        resetCount();
    }
}
