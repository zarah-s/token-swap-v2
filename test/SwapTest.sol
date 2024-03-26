// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import "../src/Swap.sol";

import "../src/ERC20.sol";

import "../src/interface/ISwap.sol";

import "../src/interface/IERC20.sol";

contract SwapContractTest is Test {
    ISwap swapContract;
    IERC20 dai;
    IERC20 link;
    IERC20 eth;

    address AddrEth = address(0x477b144FbB1cE15554927587f18a27b241126FBC);
    address AddrDai = address(0xe902aC65D282829C7a0c42CAe165D3eE33482b9f);
    address AddrLink = address(0x6a37809BdFC0aC7b73355E82c1284333159bc5F0);

    function setUp() public {
        dai = IERC20(0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357);
        link = IERC20(0xf8Fb3713D459D7C1018BD0A49D19b4C44290EBE5);
        eth = IERC20(0xb16F35c0Ae2912430DAc15764477E179D9B9EbEa);
        swapContract = ISwap(0x2106a21bc6CF3aA7ea04ea810AfB2041342BcB48);
    }

    function testSwapEthDai() public {
        switchSigner(AddrDai);
        uint256 balance = dai.balanceOf(AddrDai);
        dai.transfer(address(swapContract), balance);

        switchSigner(AddrEth);
        uint balanceOfDaiBeforeSwap = dai.balanceOf(AddrEth);
        eth.approve(address(swapContract), 1);

        swapContract.swapEthDai(1);

        uint balanceOfDaiAfterSwap = dai.balanceOf(AddrEth);

        assertGt(balanceOfDaiAfterSwap, balanceOfDaiBeforeSwap);
    }

    function testSwapEthLink() public {
        switchSigner(AddrLink);
        uint256 balance = link.balanceOf(AddrLink);
        link.transfer(address(swapContract), balance);

        switchSigner(AddrEth);
        uint balanceOfLinkBeforeSwap = link.balanceOf(AddrEth);
        eth.approve(address(swapContract), 1);
        console.log("balanceOfLinkBeforeSwap", balanceOfLinkBeforeSwap);
        swapContract.swapEthLink(1);

        uint balanceOflinkAfterSwap = link.balanceOf(AddrEth);

        assertGt(balanceOflinkAfterSwap, balanceOfLinkBeforeSwap);
    }

    function testSwapLinkDai() public {
        switchSigner(AddrDai);
        uint256 balance = dai.balanceOf(AddrDai);
        dai.transfer(address(swapContract), balance);

        switchSigner(AddrLink);
        uint balanceOfDaiBeforeSwap = dai.balanceOf(AddrLink);
        link.approve(address(swapContract), 1);

        swapContract.swapLinkDai(1);

        uint balanceOfDaiAfterSwap = dai.balanceOf(AddrLink);

        assertGt(balanceOfDaiAfterSwap, balanceOfDaiBeforeSwap);
    }

    function testSwapLinkEth() public {
        switchSigner(AddrEth);
        uint256 balance = eth.balanceOf(AddrEth);
        eth.transfer(address(swapContract), balance);

        switchSigner(AddrLink);
        uint balanceOfLinkBeforeSwap = eth.balanceOf(AddrLink);
        link.approve(address(swapContract), 1);

        swapContract.swapLinkEth(1);

        uint balanceOfLinkAfterSwap = eth.balanceOf(AddrLink);

        assertGt(balanceOfLinkAfterSwap, balanceOfLinkBeforeSwap);
    }

    function testSwapDaiLink() public {
        switchSigner(AddrLink);
        uint256 balance = link.balanceOf(AddrLink);
        link.transfer(address(swapContract), balance);

        switchSigner(AddrDai);
        uint balanceOfLinkBeforeSwap = link.balanceOf(AddrDai);
        dai.approve(address(swapContract), 1);

        swapContract.swapDaiLink(1);

        uint balanceOfLinkAfterSwap = link.balanceOf(AddrDai);

        assertGt(balanceOfLinkAfterSwap, balanceOfLinkBeforeSwap);
    }

    function testSwapDaiEth() public {
        switchSigner(AddrEth);
        uint256 balance = eth.balanceOf(AddrEth);
        eth.transfer(address(swapContract), balance);

        switchSigner(AddrDai);
        uint balanceOfEthBeforeSwap = eth.balanceOf(AddrDai);
        dai.approve(address(swapContract), 1);

        swapContract.swapDaiEth(1);

        uint balanceOfEthAfterSwap = eth.balanceOf(AddrDai);

        assertGt(balanceOfEthAfterSwap, balanceOfEthBeforeSwap);
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }

    function switchSigner(address _newSigner) public {
        address foundrySigner = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
        if (msg.sender == foundrySigner) {
            vm.startPrank(_newSigner);
        } else {
            vm.stopPrank();
            vm.startPrank(_newSigner);
        }
    }
}
