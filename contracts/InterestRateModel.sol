// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InterestRateModel {
    uint256 public baseRate;
    uint256 public collateralFactor;

    constructor(uint256 _baseRate, uint256 _collateralFactor) {
        baseRate = _baseRate;
        collateralFactor = _collateralFactor;
    }

    function getInterestRate(uint256 amount, uint256 collateral) external view returns (uint256) {
        return baseRate + (amount / collateral) * collateralFactor;
    }
}
