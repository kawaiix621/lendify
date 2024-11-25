// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CollateralManager {
    mapping(address => uint256) public collateralBalances;

    event CollateralDeposited(address indexed user, uint256 amount);
    event CollateralReleased(address indexed user, uint256 amount);

    function depositCollateral(address user, uint256 amount) external {
        collateralBalances[user] += amount;

        emit CollateralDeposited(user, amount);
    }

    function releaseCollateral(address user, uint256 amount) external {
        require(collateralBalances[user] >= amount, "Insufficient collateral");
        collateralBalances[user] -= amount;

        emit CollateralReleased(user, amount);
    }
}
