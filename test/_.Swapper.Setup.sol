// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Swapper} from "../src/Swapper.sol";

contract SwapSetup is Test, Swapper {
    Swapper internal swapContract;
    address internal testUser;
    string  internal MAINNET_URL;
    uint256 internal amountIn;


    function _setUp() public {
        testUser = address(0x1);

        MAINNET_URL = vm.envString("MAINNET_URL");

        uint256 etherium = vm.createFork(MAINNET_URL);
        vm.selectFork(etherium);

        swapContract = new Swapper();

        vm.deal(testUser, 10 ether);

        amountIn = 1 ether;
    }
}
