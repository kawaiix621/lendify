// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Basic ERC-20 Token
/// @dev Implements the ERC-20 Token Standard
contract ERC20Token {
    // Token metadata
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    // Balances and allowances
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// @dev Constructor to initialize the token metadata and mint initial supply
    /// @param _name The name of the token
    /// @param _symbol The symbol of the token
    /// @param _decimals The number of decimals for the token
    /// @param _initialSupply The initial token supply (in whole units)
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * (10 ** uint256(decimals));
        balances[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /// @dev Returns the balance of a specific account
    /// @param account The address of the account to query
    /// @return The balance of the account
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    /// @dev Transfers tokens from the caller to a specific address
    /// @param recipient The address to transfer tokens to
    /// @param amount The amount of tokens to transfer
    /// @return A boolean value indicating whether the operation succeeded
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(balances[msg.sender] >= amount, "ERC20: insufficient balance");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /// @dev Approves a spender to spend a specific amount on behalf of the caller
    /// @param spender The address authorized to spend
    /// @param amount The amount to authorize
    /// @return A boolean value indicating whether the operation succeeded
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");

        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /// @dev Returns the remaining amount a spender is allowed to spend on behalf of an owner
    /// @param owner The address of the token owner
    /// @param spender The address authorized to spend
    /// @return The remaining allowance for the spender
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    /// @dev Transfers tokens on behalf of an owner to a recipient
    /// @param sender The address of the token owner
    /// @param recipient The address to transfer tokens to
    /// @param amount The amount of tokens to transfer
    /// @return A boolean value indicating whether the operation succeeded
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(balances[sender] >= amount, "ERC20: insufficient balance");
        require(allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");

        balances[sender] -= amount;
        balances[recipient] += amount;
        allowances[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    /// @dev Mints new tokens and assigns them to a specific account
    /// @param account The address to receive the newly minted tokens
    /// @param amount The amount of tokens to mint
    function mint(address account, uint256 amount) public {
        require(account != address(0), "ERC20: mint to the zero address");

        totalSupply += amount;
        balances[account] += amount;

        emit Transfer(address(0), account, amount);
    }

    /// @dev Burns tokens from a specific account, reducing total supply
    /// @param account The address of the account to burn tokens from
    /// @param amount The amount of tokens to burn
    function burn(address account, uint256 amount) public {
        require(account != address(0), "ERC20: burn from the zero address");
        require(balances[account] >= amount, "ERC20: insufficient balance to burn");

        balances[account] -= amount;
        totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }
}
