async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const ERC20Token = await ethers.getContractFactory("ERC20Token");
    const token = await ERC20Token.deploy("Lendify Token", "LDF", 18, 1000000);

    const CollateralManager = await ethers.getContractFactory("CollateralManager");
    const collateralManager = await CollateralManager.deploy();

    const InterestRateModel = await ethers.getContractFactory("InterestRateModel");
    const interestRateModel = await InterestRateModel.deploy(5, 2);

    const LendifyCore = await ethers.getContractFactory("LendifyCore");
    const lendifyCore = await LendifyCore.deploy(token.address, collateralManager.address, interestRateModel.address);

    console.log("Contracts deployed:");
    console.log("Token:", token.address);
    console.log("Collateral Manager:", collateralManager.address);
    console.log("Interest Rate Model:", interestRateModel.address);
    console.log("Lendify Core:", lendifyCore.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
