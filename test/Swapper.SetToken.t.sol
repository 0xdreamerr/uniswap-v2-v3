// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Swapper} from "../src/Swapper.sol";
import {SwapSetup} from "./_.Swapper.Setup.sol";

contract SetTokenTest is Test, SwapSetup {

    function setUp() public {
        _setUp();
    }

    function test_setToken() public {
        address initValue = swapContract.quoteToken();

        swapContract.setToken(address(0x1));

        address finalValue = swapContract.quoteToken();

        assertEq(finalValue, address(0x1));
        assertNotEq(initValue, finalValue);
    }
}