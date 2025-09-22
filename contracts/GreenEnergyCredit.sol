// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/// @title Green Energy Credit (GEC) Token
/// @notice Simple ERC20-like token representing renewable energy credits
contract GreenEnergyCredit {
    // --- Token metadata ---
    string public name = "Green Energy Credit";
    string public symbol = "GEC";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    // --- Balances & allowances ---
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // --- Events ---
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Minted(address indexed to, uint256 amount);
    event Retired(address indexed from, uint256 amount);

    // --- Admin & Attesters ---
    address public owner;
    mapping(address => bool) public attester;

    // --- Conversion & Pricing ---
    uint256 public gecPerKWh = 1e18;       // 1 GEC per 1 kWh
    uint256 public pricePerGEC = 1e18;     // Example: 1 stablecoin token unit per GEC
    IERC20 public stablecoin;              // Reference to stablecoin (minimal interface)

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyAttester() {
        require(attester[msg.sender], "Not attester");
        _;
    }

    constructor(address stablecoinAddress) {
        owner = msg.sender;
        stablecoin = IERC20(stablecoinAddress);
    }

    // --- ERC20 Core ---
    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "Invalid to");
        require(balanceOf[from] >= amount, "Insufficient balance");
        unchecked {
            balanceOf[from] -= amount;
        }
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(allowance[from][msg.sender] >= amount, "Allowance low");
        unchecked {
            allowance[from][msg.sender] -= amount;
        }
        _transfer(from, to, amount);
        return true;
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "Invalid to");
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
        emit Minted(to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        require(balanceOf[from] >= amount, "Not enough to burn");
        unchecked {
            balanceOf[from] -= amount;
            totalSupply -= amount;
        }
        emit Transfer(from, address(0), amount);
        emit Retired(from, amount);
    }

    // --- Attester & Minting ---
    function setAttester(address a, bool allowed) external onlyOwner {
        attester[a] = allowed;
    }

    function mintFor(address to, uint256 kWh) external onlyAttester {
        require(kWh > 0, "kWh > 0");
        uint256 amount = (kWh * gecPerKWh) / 1e18;
        _mint(to, amount);
    }

    // --- Company Purchase ---
    function setPrice(uint256 newPrice) external onlyOwner {
        pricePerGEC = newPrice;
    }

    function buyGEC(uint256 gecAmount) external {
        require(gecAmount > 0, "amount>0");
        uint256 cost = (gecAmount * pricePerGEC) / 1e18;
        require(stablecoin.transferFrom(msg.sender, address(this), cost), "Payment failed");
        _mint(msg.sender, gecAmount);
    }

    // --- Retirement ---
    function retire(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    // --- Withdraw collected stablecoins ---
    function withdrawStable(address to, uint256 amount) external onlyOwner {
        require(stablecoin.transfer(to, amount), "Withdraw failed");
    }
}

/// @notice Minimal ERC20 interface for stablecoin
interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}
