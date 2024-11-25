const { expect } = require("chai");

describe("LendifyCore", function () {
    it("Should create a loan", async function () {
        const [owner] = await ethers.getSigners();

        const ERC20Token = await ethers.getContractFactory("ERC20Token");
        const token = await ERC20Token.deploy("Lendify Token", "LDF", 18, 1000000);

        const CollateralManager = await ethers.getContractFactory("CollateralManager");
        const collateralManager = await CollateralManager.deploy();

        const InterestRateModel = await ethers.getContractFactory("InterestRateModel");
        const interestRateModel = await InterestRateModel.deploy(5, 2);

        const LendifyCore = await ethers.getContractFactory("LendifyCore");
        const lendifyCore = await LendifyCore.deploy(token.address, collateralManager.address, interestRateModel.address);

        await lendifyCore.createLoan(1000, 200);
        const loans = await lendifyCore.loans(owner.address);
        expect(loans[0].amount).to.equal(1000);
    });
});
