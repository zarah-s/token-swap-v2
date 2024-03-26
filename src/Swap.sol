// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// import {AggregatorV3Interface} from "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {IERC20} from "./IERC20.sol";

contract Swap {
    // interfaces
    IERC20 public daiTokenAddr;
    IERC20 public linkTokenAddr;
    IERC20 public wethTokenAddr;

    // contract addresses
    address public constant ethAddress =
        0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9; // Address of Ether (ETH)
    address public constant linkAddress =
        0x779877A7B0D9E8603169DdbD7836e478b4624789; // Address of Chainlink token (LINK)
    address public constant daiAddress =
        0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6; // Address of Dai stablecoin (DAI)

    AggregatorV3Interface internal ethUsdPriceFeed;
    AggregatorV3Interface internal linkUsdPriceFeed;
    AggregatorV3Interface internal daiUsdPriceFeed;

    constructor(
        address _ethUsdPriceFeed,
        address _linkUsdPriceFeed,
        address _daiUsdPriceFeed
    ) {
        ethUsdPriceFeed = AggregatorV3Interface(_ethUsdPriceFeed);
        linkUsdPriceFeed = AggregatorV3Interface(_linkUsdPriceFeed);
        daiUsdPriceFeed = AggregatorV3Interface(_daiUsdPriceFeed);

        daiTokenAddr = IERC20(daiAddress);
        linkTokenAddr = IERC20(linkAddress);
        wethTokenAddr = IERC20(ethAddress);
    }

    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer(
        AggregatorV3Interface priceFeed
    ) public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return answer;
    }

    // swap ether for link
    function swapEthForLink(uint256 _amount) external {
        // getting prices
        int ethPrice = getChainlinkDataFeedLatestAnswer(ethUsdPriceFeed);
        int linkPrice = getChainlinkDataFeedLatestAnswer(linkUsdPriceFeed);

        // convert eth amount to link
        uint256 linkAmount = (_amount * uint256(ethPrice)) / uint256(linkPrice);

        // confirming user balance
        require(
            wethTokenAddr.balanceOf(msg.sender) >= _amount,
            "You dont not have enough tokens to swap"
        );

        // transfer ether from user to contract
        wethTokenAddr.transferFrom(msg.sender, address(this), _amount);

        // transfer link to user from contract
        linkTokenAddr.transfer(msg.sender, linkAmount);
    }

    // swap link for ether
    function swapLinkForEth(uint256 _amount) external {
        // getting prices
        int ethPrice = getChainlinkDataFeedLatestAnswer(ethUsdPriceFeed);
        int linkPrice = getChainlinkDataFeedLatestAnswer(linkUsdPriceFeed);

        // convert eth amount to link
        uint256 linkAmount = (_amount * uint256(linkPrice)) / uint256(ethPrice);

        // confirming user balance
        require(
            linkTokenAddr.balanceOf(msg.sender) >= _amount,
            "You dont not have enough tokens to swap"
        );

        // transfer ether from user to contract
        require(
            linkTokenAddr.transferFrom(msg.sender, address(this), _amount),
            "transaction not succesful"
        );

        // transfer link to user from contract
        wethTokenAddr.transfer(msg.sender, linkAmount);
    }

    // swap dai for ether
    function swapDaiForEth(uint256 _amount) external {
        // getting prices
        int ethPrice = getChainlinkDataFeedLatestAnswer(ethUsdPriceFeed);
        int daiPrice = getChainlinkDataFeedLatestAnswer(daiUsdPriceFeed);

        // convert dai for eth
        uint256 daiAmount = (_amount * uint256(daiPrice)) / uint256(ethPrice);

        // confirming user balance
        require(
            daiTokenAddr.balanceOf(msg.sender) >= _amount,
            "You dont not have enough tokens to swap"
        );

        // transfer ether from user to contract
        require(
            daiTokenAddr.transferFrom(msg.sender, address(this), _amount),
            "transaction not succesful"
        );

        // transfer ether to user from contract
        wethTokenAddr.transfer(msg.sender, daiAmount);
    }

    // swap ether for dai
    function swapEthForDai(uint256 _amount) external {
        // getting prices
        int ethPrice = getChainlinkDataFeedLatestAnswer(ethUsdPriceFeed);
        int daiPrice = getChainlinkDataFeedLatestAnswer(daiUsdPriceFeed);

        // convert eth amount to dai
        uint256 ethAmount = (_amount * uint256(ethPrice)) / uint256(daiPrice);

        // confirming user balance
        require(
            wethTokenAddr.balanceOf(msg.sender) >= _amount,
            "You dont not have enough tokens to swap"
        );

        // transfer ether from user to contract
        require(
            wethTokenAddr.transferFrom(msg.sender, address(this), _amount),
            "transaction not succesful"
        );

        // transfer dai to user from contract
        daiTokenAddr.transfer(msg.sender, ethAmount);
    }

    function swapLinkToDai(uint256 _amount) external {
        // getting prices
        int linkPrice = getChainlinkDataFeedLatestAnswer(linkUsdPriceFeed);
        int daiPrice = getChainlinkDataFeedLatestAnswer(daiUsdPriceFeed);

        // convert eth amount to dai
        uint256 daiAmount = (_amount * uint256(linkPrice)) / uint256(daiPrice);

        // confirming user balance
        require(
            linkTokenAddr.balanceOf(msg.sender) >= _amount,
            "You dont not have enough tokens to swap"
        );

        // transfer ether from user to contract
        require(
            linkTokenAddr.transferFrom(msg.sender, address(this), _amount),
            "transaction not succesful"
        );

        // transfer dai to user from contract
        daiTokenAddr.transfer(msg.sender, daiAmount);
    }

    function swapDaiToLink(uint256 _amount) external {
        // getting prices
        int linkPrice = getChainlinkDataFeedLatestAnswer(linkUsdPriceFeed);
        int daiPrice = getChainlinkDataFeedLatestAnswer(daiUsdPriceFeed);

        // convert eth amount to dai
        uint256 linkAmount = (_amount * uint256(daiPrice)) / uint256(linkPrice);

        // confirming user balance
        require(
            daiTokenAddr.balanceOf(msg.sender) >= _amount,
            "You dont not have enough tokens to swap"
        );

        // transfer ether from user to contract
        require(
            daiTokenAddr.transferFrom(msg.sender, address(this), _amount),
            "transaction not succesful"
        );

        // transfer dai to user from contract
        linkTokenAddr.transfer(msg.sender, linkAmount);
    }
}
