const main = async ()=> {
    const civicLinkContractFactory = await hre.ethers.getContractFactory('CivicLink');
    const civicLinkContract = await civicLinkContractFactory.deploy();
    await civicLinkContract.waitForDeployment();
};


const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};


runMain();