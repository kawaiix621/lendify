// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Token.sol";
import "./CollateralManager.sol";
import "./InterestRateModel.sol";

contract LendifyCore {
    ERC20Token public lendingToken;
    CollateralManager public collateralManager;
    InterestRateModel public interestRateModel;

    struct Loan {
        address borrower;
        uint256 amount;
        uint256 collateral;
        uint256 interestRate;
        uint256 startTime;
        bool isRepaid;
    }

    mapping(address => Loan[]) public loans;

    event LoanCreated(address indexed borrower, uint256 amount, uint256 collateral, uint256 interestRate);
    event LoanRepaid(address indexed borrower, uint256 amount);

    constructor(
        address _lendingToken,
        address _collateralManager,
        address _interestRateModel
    ) {
        lendingToken = ERC20Token(_lendingToken);
        collateralManager = CollateralManager(_collateralManager);
        interestRateModel = InterestRateModel(_interestRateModel);
    }

    function createLoan(uint256 amount, uint256 collateral) external {
        require(amount > 0, "Amount must be greater than 0");
        require(collateral > 0, "Collateral must be greater than 0");

        uint256 interestRate = interestRateModel.getInterestRate(amount, collateral);

        collateralManager.depositCollateral(msg.sender, collateral);

        loans[msg.sender].push(
            Loan({
                borrower: msg.sender,
                amount: amount,
                collateral: collateral,
                interestRate: interestRate,
                startTime: block.timestamp,
                isRepaid: false
            })
        );

        lendingToken.transfer(msg.sender, amount);

        emit LoanCreated(msg.sender, amount, collateral, interestRate);
    }

    function repayLoan(uint256 loanId) external {
        Loan storage loan = loans[msg.sender][loanId];
        require(!loan.isRepaid, "Loan already repaid");

        uint256 repaymentAmount = loan.amount + ((loan.amount * loan.interestRate) / 100);
        lendingToken.transferFrom(msg.sender, address(this), repaymentAmount);

        collateralManager.releaseCollateral(msg.sender, loan.collateral);
        loan.isRepaid = true;

        emit LoanRepaid(msg.sender, repaymentAmount);
    }
}
