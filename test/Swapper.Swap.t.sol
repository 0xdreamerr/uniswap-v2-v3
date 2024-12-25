// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Swapper} from "../src/Swapper.sol";
import {SwapSetup} from "./_.Swapper.Setup.sol";

contract SwapTest is Test, SwapSetup {

    function setUp() public {
        _setUp();
    }

    function test_swapV2() public {
        vm.startPrank(testUser);
        uint256 initialDaiBalance = IERC20(quoteToken).balanceOf(testUser);

        swapContract.swapV2{value: amountIn}(quoteToken);

        uint256 finalDaiBalance = IERC20(quoteToken).balanceOf(testUser);
        
        assertGt(finalDaiBalance, initialDaiBalance);
        vm.stopPrank();
    }

    function test_swapV3() public {
        vm.startPrank(testUser);
        uint256 initialDaiBalance = IERC20(quoteToken).balanceOf(testUser);

        swapContract.swapV3{value: amountIn}(quoteToken);

        uint256 finalDaiBalance = IERC20(quoteToken).balanceOf(testUser);
        
        assertGt(finalDaiBalance, initialDaiBalance);
        vm.stopPrank();
    }

    function test_RevertIf_ZeroAddress() public {
        address quoteToken = address(0);

        vm.startPrank(testUser);
        vm.expectRevert();
        swapContract.swapV3{value: amountIn}(quoteToken);
    }

    function test_RevertIf_NotEnoughValue() public {
        amountIn = 0;

        vm.startPrank(testUser);

        vm.expectRevert();
        swapContract.swapV3{value: amountIn}(quoteToken);
    }

    
}