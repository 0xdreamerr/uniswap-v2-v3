// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Swapper} from "../src/Swapper.sol";
import {SwapSetup} from "./_.Swapper.Setup.sol";

contract WithdrawTest is Test, SwapSetup {

    function setUp() public {
        _setUp();
    }

    function test_withdrawToken() public {
        deal(quoteToken, address(swapContract), 1000 * 10 ** 18);
        uint256 amount = 200;

        vm.startPrank(testUser);

        uint256 initialUserBalance = IERC20(quoteToken).balanceOf(testUser);
        
        swapContract.withdrawToken(amount, quoteToken);

        uint256 finalUserBalance = IERC20(quoteToken).balanceOf(testUser);
        vm.stopPrank();


        assertEq(finalUserBalance, initialUserBalance + (amount));
    }   
}