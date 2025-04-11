const main = async ()=> {
    const [deployer] = await hre.ethers.getSigners();
    const accountBalance = await hre.ethers.provider.getBalance(deployer);
    
    console.log("Deploying contracts with account: ", deployer.address);
    console.log("Account Balance ", accountBalance.toString());


    const civicLinkContractFactory = await hre.ethers.getContractFactory("CivicLink"); 
    const civicLinkContract = await civicLinkContractFactory.deploy();

    await civicLinkContract.waitForDeployment();
    console.log("Contract deployed to:", civicLinkContract.target);
}



const runMain = async ()=> {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error)
        process.exit(1);
    }
}

runMain();