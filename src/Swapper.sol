// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

interface IUniswapV2Router {
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
}

address constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
address constant UNISWAP_V3_ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

error ZeroAddress();
error NotEnoughValue();
error InsufficientBalance();

contract Swapper {
    using SafeERC20 for IERC20;

    address public quoteToken = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI

    function setToken(address _quoteToken) public {
        quoteToken = _quoteToken;
    }

    function swapV2(address _quoteToken) public payable {
        require(_quoteToken != address(0), ZeroAddress());
        require(msg.value > 0, NotEnoughValue());

        address[] memory path;
        path = new address[](2);
        path[0] = WETH;
        path[1] = _quoteToken;

        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactETHForTokens{value: msg.value} (0, path, msg.sender, block.timestamp);
    }


    function swapV3(address _quoteToken) public payable returns(uint256 amountOut){
        require(_quoteToken != address(0), ZeroAddress());
        require(msg.value > 0, NotEnoughValue());
        
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH,
                tokenOut: _quoteToken,
                fee: 3000,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: msg.value,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = ISwapRouter(UNISWAP_V3_ROUTER).exactInputSingle{value: msg.value}(params);
    }


    function withdrawToken(uint256 _amount, address _tokenAddress) public {
        require(_amount > 0, NotEnoughValue());
        require(_tokenAddress != address(0), ZeroAddress());

        IERC20 token = IERC20(_tokenAddress);
        require(token.balanceOf(address(this)) >= _amount, InsufficientBalance());
        token.safeTransfer(msg.sender, _amount);
    }

}