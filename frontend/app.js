// app.js
const connectBtn = document.getElementById("connectButton");
const searchInput = document.getElementById("searchInput");
const searchButton = document.querySelector('#section_1 button');
let contract;
let signer;

// Initialize provider only when needed
async function initProvider() {
    if (typeof window.ethereum === 'undefined') {
        alert('Please install MetaMask!');
        return;
    }
    
    try {
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        connectBtn.textContent = `${accounts[0].slice(0,6)}...${accounts[0].slice(-4)}`;
        return new ethers.providers.Web3Provider(window.ethereum);
    } catch (error) {
        console.error("Error connecting wallet:", error);
        alert('Error connecting wallet');
    }
}

// Connect Wallet Button Handler
connectBtn.addEventListener('click', async () => {
    const provider = await initProvider();
    if (!provider) return;
    
    signer = provider.getSigner();
    await initializeContract();
});

async function initializeContract() {
    const contractAddress = '0xB3be2E51EdAeC9dB5CE98Db1C04b66895774Fd9a'; 
    
    const contractABI = [
        await 'artifacts/contracts/CivicLink.sol/CivicLink.json' // "abi" array
    ];

    contract = new ethers.Contract(contractAddress, contractABI, signer);
}

// Search Handler
searchButton.addEventListener('click', async (e) => {
    e.preventDefault();
    const searchTerm = searchInput.value;
    
    if (!contract) {
        alert('Please connect wallet first');
        return;
    }

    try {
        const officials = await contract.searchOfficials(searchTerm);
        displayResults(officials);
    } catch (error) {
        console.error("Search error:", error);
        alert('Error searching officials');
    }
});

// Display results in the DOM
function displayResults(officials) {
    const resultsContainer = document.createElement('div');
    resultsContainer.id = 'search-results';

    officials.forEach(official => {
        const officialDiv = document.createElement('div');
        officialDiv.className = 'official-card';
        officialDiv.innerHTML = `
            <h3>${official.name}</h3>
            <p>Role: ${official.role}</p>
            <p>Email: ${official.contactEmail}</p>
            <p>Office: ${official.officeLine}</p>
        `;
        resultsContainer.appendChild(officialDiv);
    });

    // Clear previous results and add new ones
    const existingResults = document.getElementById('search-results');
    if (existingResults) existingResults.remove();
    
    document.querySelector('#section_1').appendChild(resultsContainer);
}