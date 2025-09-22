# 🌱⚡ Green Energy Credit (GEC) Smart Contract

## Overview

The **Green Energy Credit (GEC)** contract is a blockchain-based system for creating, trading, and retiring **renewable energy credits**.

It allows renewable energy producers or trusted authorities (called **attesters**) to mint on-chain tokens when users **prove renewable energy generation/consumption**. These tokens can then be purchased by companies to **offset their carbon footprint**.

By putting this process on-chain, we get:
 
- Transparency ✅
- Traceability ✅
- No double-counting ✅
- Automated retirement of credits ✅

---

## What this contract does

1. **Tokenization of Energy Credits**

   - Each `GEC` token represents a fixed amount of renewable energy (e.g., 1 kWh).
   - Producers or trusted authorities mint tokens for verified renewable energy usage.

2. **Tradable ERC20-like Token**

   - GEC follows a simple ERC20-like implementation (self-contained, no imports).
   - Companies and individuals can **buy, hold, and transfer** these credits.

3. **Buying with Stablecoin**

   - Companies purchase credits using a stablecoin (e.g., USDC/DAI).
   - Price per GEC is set by the contract owner.

4. **Retirement Mechanism**

   - To claim offset benefits, companies **retire (burn) GECs**.
   - Once retired, they cannot be reused — ensuring real carbon offsetting.

5. **Admin & Governance**
   - Contract owner can:
     - Add/remove trusted attesters.
     - Adjust GEC pricing.
     - Withdraw stablecoin proceeds.

---

## Why this matters

🌍 **Climate Change & Transparency:**  
Carbon markets often face criticism for **double-counting, poor traceability, and lack of transparency**. By putting credits on-chain, every mint, transfer, and retirement is **publicly verifiable**.

⚡ **Renewable Incentivization:**  
Energy producers are rewarded for renewable generation, while companies can meet sustainability goals with **provable offsets**.

🤝 **Tradability:**  
Since GEC is ERC20-like, it can be integrated with **DEXs, marketplaces, or DeFi protocols**, unlocking liquidity for sustainability assets.

---

## Key Features

- **Minting by Attesters:** Only trusted authorities can mint new credits to prevent fraud.
- **Stablecoin Integration:** Companies pay in stablecoins, making it easy to adopt.
- **Self-contained ERC20-like logic:** No external imports; balances, allowances, and transfers are built-in.
- **Retirement (Burning):** Retired credits are permanently removed from circulation.
- **Owner Controls:** Pricing, attesters, and stablecoin withdrawals are managed by the owner.

---

## Example Workflow

1. **Producer generates renewable energy.**

   - Example: A solar farm generates **1,000 kWh**.
   - Attester verifies this and calls `mintFor(user, 1000)`.

2. **GEC tokens are minted.**

   - If 1 kWh = 1 GEC, then 1,000 GEC tokens are created.
   - Tokens are stored in the producer’s wallet.

3. **Company buys credits.**

   - A company calls `buyGEC(500)` to purchase 500 GEC.
   - Stablecoin (e.g., USDC) is transferred to the contract.
   - 500 GEC tokens are minted to the buyer.

4. **Company retires credits.**
   - To offset emissions, the company calls `retire(500)`.
   - These tokens are burned and can never be reused.
   - Public record on-chain proves the offset.

---

## Security Considerations

- **Attester trust:** Minting power is centralized to trusted entities. Without this, fake energy claims could occur.
- **Replay protection:** Off-chain verification should include unique IDs/timestamps to prevent double-minting.
- **Stablecoin dependency:** Ensure the chosen stablecoin (e.g., USDC/DAI) is reputable and secure.
- **Admin powers:** The owner controls critical functions. A multisig wallet is recommended.

---

## Deployment

1. Deploy a stablecoin contract (or use existing USDC/DAI on testnet).
2. Deploy the `GreenEnergyCredit` contract with stablecoin address.
3. Add attesters using `setAttester()`.
4. Mint credits with `mintFor()`.
5. Companies can `buyGEC()` and later `retire()`.

---

## License

MIT License. Free to use, improve, and deploy.

---
